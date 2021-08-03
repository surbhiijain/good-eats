//
//  ComposeViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "Dish.h"
#import "Restaurant.h"
#import "HCSStarRatingView.h"
#import "APIManager.h"
#import "RestaurantSearchViewController.h"
#import <YelpAPI/YLPLocation.h>
#import <YelpAPI/YLPBusiness.h>
#import <ChameleonFramework/Chameleon.h>

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *dishField;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;

@property (nonatomic, strong) NSMutableArray *tags;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) YLPCoordinate *userCoordinate;

@property(nonatomic, strong) YLPBusiness *selectedRestaurant;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearFields];
    
    self.tags = [NSMutableArray new];
    [self.starRatingView setTintColor:[UIColor systemYellowColor]];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
    
}

- (void)LocationManager:(LocationManager *)locationManager
      setUpWithLocation:(CLLocation *)location {
    
    self.userCoordinate = [[YLPCoordinate alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
}

- (IBAction)didTapPhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // create menu options for users to either take a photo with the camera or upload from their photo library if their device supports a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSMutableArray *photoOptions = [NSMutableArray new];
        
        UIAction *camera = [UIAction actionWithTitle:@"Camera" image:nil identifier:nil handler:^(UIAction* action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        [photoOptions addObject:camera];
        
        
        UIAction *photoLibrary = [UIAction actionWithTitle:@"Photo Library" image:nil identifier:nil handler:^(UIAction* action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        [photoOptions addObject:photoLibrary];
        
        [self.imageButton setMenu:[UIMenu menuWithChildren:photoOptions]];
    }
    // otherwise, go directly into the photo library
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 300)];
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:resizedImage forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image
                withSize:(CGSize)size {
    
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)didTapRestaurantButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"restaurantSearchSegue" sender:self];
}

- (void)RestaurantSearchViewController:(RestaurantSearchViewController *) controller selectedRestaurant:(YLPBusiness *) yelpRestaurant {
    self.selectedRestaurant = yelpRestaurant;
    [self.restaurantButton setTitle:yelpRestaurant.name forState:UIControlStateNormal];
}

- (IBAction)didTapCancel:(id)sender {
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:0];
    [self clearFields];
}

- (IBAction)didTapDone:(id)sender {
    if (![self validPost]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post not completed"
                                                                       message:@"Please upload an image and enter the restaurant and dish names"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self getOrCreateParseRestaurant:self.selectedRestaurant withCompletion:^(Restaurant *restaurant) {
        Dish *dish = [self getDish:restaurant];
        [self createPost:dish withRestaurant:restaurant];
    }];
    
}

- (BOOL) validPost {
    return (self.imageButton.imageView.image && ![self.restaurantButton.titleLabel.text  isEqual: @"select a restaurant"] && self.dishField.text.length > 0);
}

- (void)getOrCreateParseRestaurant:(YLPBusiness *) business
                    withCompletion:(void(^)(Restaurant * restaurant)) completion {
    
    NSNumber *latitude = [NSNumber numberWithDouble:business.location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:business.location.coordinate.longitude];
    
    NSDictionary *constraints = [[NSDictionary alloc] initWithObjects:@[business.name, latitude, longitude] forKeys:@[@"name", @"latitude", @"longitude"]];
    
    [[APIManager shared] fetchAllRestaurantsWithOrderKey:nil withLimit:@1 withConstraints:constraints withCompletion:^(NSMutableArray *restaurants, NSError *error) {
        Restaurant *restaurant;
        if (restaurants && restaurants.count != 0) {
            restaurant = restaurants[0];
        }
        else {
            NSString *abrevLocation = [NSString stringWithFormat:@"%@, %@", business.location.city, business.location.stateCode];
            restaurant = [[Restaurant alloc] initWithName:business.name withLatitude:latitude withLongitude:longitude withLocation:abrevLocation];
            [restaurant save];
        }
        completion(restaurant);
    }];
}

- (Dish *) getDish:(Restaurant *) restaurant {
    Dish *dish;
    for (Dish *d in restaurant.dishes) {
        if ([d.name isEqual:self.dishField.text]) {
            dish = d;
        }
    }
    if (!dish) {
        dish = [[Dish alloc] initWithName:self.dishField.text withRestaurant:restaurant.name withRestaurantID:restaurant.objectId];
        [restaurant addDish:dish];
        [restaurant saveInBackground];
    }
    return dish;
}


- (void) createPost:(Dish *)dish
     withRestaurant:(Restaurant *) restaurant {
    NSNumber *rating = [NSNumber numberWithFloat:self.starRatingView.value];
    
    [Post postUserImage:self.imageButton.imageView.image withCaption:self.captionField.text withDish:dish withRating:rating withTags:self.tags withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"imaged not posted");
        } else {
            [dish addCheckInWithRating:rating];
            [restaurant addCheckIn];
            [self.delegate ComposeViewController:self postedRestaurant:restaurant];
        }
        
        self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
        [self clearFields];
    }];
}

- (IBAction)didTapTag:(UIButton *)sender {
    
    NSString *tagName = [sender currentTitle];
    
    if ([self.tags containsObject:tagName]) {
        [self.tags removeObject:tagName];
        [sender setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
        return;
    }
    
    [self.tags addObject:tagName];
    [sender setBackgroundColor:[UIColor colorWithRed:0/255.0 green:109/255.0 blue:119/255.0 alpha:1.0]];
}

- (void)clearFields {
    [self.restaurantButton setTitle:@"select a restaurant" forState:UIControlStateNormal];
    [self.restaurantButton setBackgroundColor:nil];
    [self.restaurantButton setTitleColor:FlatTeal forState:UIControlStateNormal];
    
    self.dishField.text = @"";
    self.captionField.text = @"";
    self.starRatingView.value = 0;
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setBackgroundColor:nil];
    [self.imageButton setTintColor:FlatTeal];
    
    UIImage *placeHolderImage =  [UIImage systemImageNamed:@"photo.fill.on.rectangle.fill"];
    [self.imageButton setBackgroundImage:placeHolderImage forState:UIControlStateNormal];
    
    [self.tagButton1 setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    [self.tagButton2 setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    [self.tagButton3 setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    [self.tagButton4 setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    [self.tagButton5 setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    
    self.tags = [[NSMutableArray alloc] init];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"restaurantSearchSegue"]) {
        RestaurantSearchViewController *restaurantSearchVC = [segue destinationViewController];
        restaurantSearchVC.delegate = self;
    }
}

@end
