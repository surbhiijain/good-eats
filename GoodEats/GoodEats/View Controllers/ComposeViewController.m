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

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *restaurantField;
@property (weak, nonatomic) IBOutlet UITextField *dishField;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(350, 350)];
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:resizedImage forState:UIControlStateNormal];
    
    // Dismiss UIImagePickerController to go back to your original view controller
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
}

- (IBAction)didTapDone:(id)sender {
    if (![self.imageButton.imageView.image isEqual:nil]) {
        Restaurant *restaurant = [[Restaurant alloc] initWithName:self.restaurantField.text withLatitude:@37.783333 withLongitude:@-122.416667];
        Dish *dish = [[Dish alloc] initWithName:self.dishField.text withRestaurant:restaurant];
//        [restaurant addDish:dish];
        
        [Post postUserImage:self.imageButton.imageView.image withCaption:self.captionField.text withDish:dish withRating:@5 withTags:[NSMutableArray new] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                NSLog(@"imaged not posted");
            } else {
                NSLog(@"IMAGE POSTED");
                // todo: send this info to feed VC + map VC
            }
        }];
        // go back to main map view
        self.tabBarController.selectedViewController
            = [self.tabBarController.viewControllers objectAtIndex:0];
    } else {
        NSLog(@"Please upload a photo");
    }
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
