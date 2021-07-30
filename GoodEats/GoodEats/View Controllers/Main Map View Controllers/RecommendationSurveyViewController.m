//
//  RecommendationSurveyViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/26/21.
//

#import "RecommendationSurveyViewController.h"
#import "DishDetailsViewController.h"
#import "Dish.h"
#import "Restaurant.h"
#import "Post.h"
#import "LocationManager.h"
#import "RecommendationManager.h"

@interface RecommendationSurveyViewController () <LocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tasteSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *adventureSegControl;

@property (nonatomic, strong) Dish *dish;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation RecommendationSurveyViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
}

- (void) LocationManager:(LocationManager *)locationManager
       setUpWithLocation:(CLLocation *)location {
    self.userLocation = location;
}

- (IBAction) didTapDone:(id)sender {
    double dist = [self getSelectedDistance];
    BOOL taste = [self getTasteImportanceBool];
    int adventureIndex = (int) self.adventureSegControl.selectedSegmentIndex;
    
    [RecommendationManager getRecommendedDishWithDist:dist withTaste:taste withAdventureIndex:adventureIndex withUserLoation:self.userLocation withCompletion:^(Dish *dish, NSString *noRecsErrorString) {
        if (noRecsErrorString) {
            [self handleNoRecommendationsFound:noRecsErrorString];
            return;
        }
        self.dish = dish;
        [self performSegueWithIdentifier:@"dishDetailsSegue" sender:self];
        
    }];
}

- (void) handleNoRecommendationsFound: (NSString *) alertMessage  {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No recommendations found"
                                                                   message:alertMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"try again"
                                                             style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (double) getSelectedDistance {
    switch (self.timeSegControl.selectedSegmentIndex) {
        case 0:
            return 1;
        case 1:
            return 5;
        case 2:
            return 15;
        case 3:
            return 30;
        default:
            break;
    }
    return 0;
}

- (BOOL) getTasteImportanceBool {
    switch (self.tasteSegControl.selectedSegmentIndex) {
        case 0:
            return TRUE;
        case 1:
            return FALSE;
        default:
            break;
    }
    return TRUE;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.dish = self.dish;
    }
}

@end
