//
//  FilterViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/22/21.
//

#import "FilterViewController.h"
#import <Parse/Parse.h>
#import "Restaurant.h"
#import "LocationManager.h"

@interface FilterViewController () <LocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegControl;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) NSMutableArray *filteredRestaurants;


@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
    
    self.filteredRestaurants = [[NSMutableArray alloc] init];
    
}
- (IBAction)didApplyFilters:(UIButton *)sender {
    [self getAllRestaurants];

}

- (double) getFilteredDistance {
    switch (self.distanceSegControl.selectedSegmentIndex) {
        case 0:
            return 1;
        case 1:
            return 5;
        case 2:
            return 20;
        default:
            break;
    }
    return 0;
}

- (void) getAllRestaurants {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKeys:@[@"dishes"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        if (restaurants != nil) {
            self.restaurants = (NSMutableArray *) restaurants;
            double filterDistance = [self getFilteredDistance];
            [self filterRestaurantsByDistance:filterDistance fromLocation:self.userLocation];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)LocationManager:(LocationManager *)locationManager setUpWithLocation:(CLLocation *)location {
    self.userLocation = location;
}

- (void) filterRestaurantsByDistance: (double) filterDistance fromLocation: (CLLocation *) userLocation {
    NSMutableArray *distances = [[NSMutableArray alloc] init];
    for (Restaurant *restaurant in self.restaurants) {
        CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:[restaurant.latitude doubleValue] longitude:[restaurant.longitude doubleValue]];
        
        CLLocationDistance locationDistance = [restaurantLocation distanceFromLocation:userLocation];
        double distanceInMiles = locationDistance * 0.000621371;

        
        if (distanceInMiles <= filterDistance) {
            [self.filteredRestaurants addObject:restaurant];
        }
    }
    [self.delegate FilterViewController:self reloadFeedWithRestaurants:self.filteredRestaurants];
    [self dismissViewControllerAnimated:YES completion:nil];
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
