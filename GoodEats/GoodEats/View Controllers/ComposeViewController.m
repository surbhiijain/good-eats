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
#import "AppDelegate.h"
#import <YelpAPI/YLPClient+Search.h>
#import <YelpAPI/YLPSortType.h>
#import <YelpAPI/YLPSearch.h>
#import <YelpAPI/YLPBusiness.h>
#import <YelpAPI/YLPLocation.h>
#import <YelpAPI/YLPCoordinate.h>


@interface ComposeViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *restaurantField;
@property (weak, nonatomic) IBOutlet UITextField *dishField;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) YLPCoordinate *userCoordinate;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tags = [NSMutableArray new];
    [self.starRatingView setTintColor:[UIColor systemYellowColor]];
    [self setUpLocationManager];
}

- (void) setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
        
        self.userCoordinate = [[YLPCoordinate alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location update failed %@", error);
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(350, 200)];
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:resizedImage forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)didTapCancel:(id)sender {
    self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
    [self clearFields];
}

- (IBAction)didTapDone:(id)sender {
    if ([self validPost]) {
        [self locateRestaurant];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post not completed"
                                                                                   message:@"Please upload an image and enter the restaurant and dish names"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL) validPost {
    return (self.imageButton.imageView.image && self.restaurantField.text.length > 0 && self.dishField.text.length > 0);
}

- (void) locateRestaurant {
    [[AppDelegate sharedClient] searchWithCoordinate:self.userCoordinate term:self.restaurantField.text limit:5 offset:0 sort:YLPSortTypeDistance completionHandler:^(YLPSearch * search, NSError * error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            YLPBusiness *business = search.businesses[0];
            YLPLocation *location = business.location;
            [self getOrCreateParseRestaurant:business withLocation:location];
        }
    }];
}

- (void)getOrCreateParseRestaurant: (YLPBusiness *) business withLocation: (YLPLocation *) location {
    
    NSNumber *latitude = [NSNumber numberWithDouble:business.location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:business.location.coordinate.longitude];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKeys:@[@"dishes"]];
    [query whereKey:@"name" equalTo:business.name];
    [query whereKey:@"latitude" equalTo:latitude];
    [query whereKey:@"longitude" equalTo:longitude];
    
    __block Restaurant *restaurant;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        // set the restaurant to the first result if one already exists
        if (restaurants != nil && restaurants.count != 0) {
            restaurant = restaurants[0];
        }
        // otherwise, create a new restaurant object
        else {
            restaurant = [[Restaurant alloc] initWithName:business.name withLatitude:latitude withLongitude:longitude];
        }
        [self getDish:restaurant];
    }];
}

- (void) getDish:(Restaurant *) restaurant {
    Dish *dish;
    for (Dish *d in restaurant.dishes) {
        if ([d.name isEqual:self.dishField.text]) {
            dish = d;
        }
    }
    if (!dish) {
        dish = [[Dish alloc] initWithName:self.dishField.text withRestaurant:restaurant.name];
        [restaurant addDish:dish];
        [restaurant saveInBackground];
    }
    
    [self createPost:dish withRestaurant:restaurant];
}


- (void) createPost:(Dish *)dish withRestaurant:(Restaurant *) restaurant {
    NSNumber *rating = [NSNumber numberWithFloat:self.starRatingView.value];
    
    [Post postUserImage:self.imageButton.imageView.image withCaption:self.captionField.text withDish:dish withRating:rating withTags:self.tags withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"imaged not posted");
        } else {
            [self.delegate ComposeViewController:self postedRestaurant:restaurant];
        }
        // go back to main map view
        self.tabBarController.selectedViewController
            = [self.tabBarController.viewControllers objectAtIndex:0];
        [self clearFields];
    }];
    

}

- (IBAction)didTapTag:(UIButton *)sender {
    
    NSString *tagName = [sender currentTitle];
    
    if (![self.tags containsObject:tagName]) {
        [self.tags addObject:tagName];
        [sender setBackgroundColor:[UIColor colorWithRed:0/255.0 green:109/255.0 blue:119/255.0 alpha:1.0]];
    } else if ([self.tags containsObject:tagName]) {
        [self.tags removeObject:tagName];
        [sender setBackgroundColor:[UIColor colorWithRed:211/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]];
    }
}

- (void)clearFields {
    self.restaurantField.text = @"";
    self.dishField.text = @"";
    self.captionField.text = @"";
    self.starRatingView.value = 0;
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    
    UIImage *placeHolderImage =  [UIImage systemImageNamed:@"photo.fill.on.rectangle.fill"];
    [self.imageButton setBackgroundImage:placeHolderImage forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
