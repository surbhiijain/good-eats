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

@interface RecommendationSurveyViewController () <LocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tasteSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *adventureSegControl;

@property (nonatomic, strong) Dish *dish;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation RecommendationSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
}

- (void)LocationManager:(LocationManager *)locationManager setUpWithLocation:(CLLocation *)location {
    self.userLocation = location;
}

- (IBAction)didTapDone:(id)sender {
    double dist = [self getSelectedDistance];
    BOOL taste = [self getTasteImportanceBool];
    int adventureIndex = (int) self.adventureSegControl.selectedSegmentIndex;
    
    __block NSMutableArray *allDishes = [[NSMutableArray alloc] init];
    __block NSMutableArray *userTriedDishes = [[NSMutableArray alloc] init];
    __block NSMutableArray *userNotTriedDishes = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *dishes = [[NSMutableArray alloc] init];
    
    [self getAllRestaurantsWithCompletion:^(NSArray *restaurants, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        [self filterRestaurants:restaurants byDistance:dist fromLocation:self.userLocation withCompletion:^(NSMutableArray *filteredRestaurants, NSMutableArray *filteredRestaurantIds) {
            if (adventureIndex == 1 || adventureIndex == 2) {
                allDishes = [self getAllDishesInRestaurants:filteredRestaurants];
            }
            if (adventureIndex == 1) {
                [self sortDishes:allDishes withTasteImportance:taste];
                [self performSegueWithIdentifier:@"dishDetailsSegue" sender:self];
                return;
            }
            [self getUsersPastPostsForRestaurants:filteredRestaurantIds withCompletion:^(NSArray *posts, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    return;
                }
                for (Post *post in posts) {
                    [userTriedDishes addObject:post.dish];
                }
                if (adventureIndex == 0) {
                    [self sortDishes:userTriedDishes withTasteImportance:taste];
                    [self performSegueWithIdentifier:@"dishDetailsSegue" sender:self];
                    return;
                }
                for (Dish *d in allDishes) {
                    if (![userTriedDishes containsObject:d]) {
                        self.dish = d;
                        [self performSegueWithIdentifier:@"dishDetailsSegue" sender:self];
                        return;
                    }
                }
                
                
            }];
        }];
    }];
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

- (void) getAllRestaurantsWithCompletion: (void(^)(NSArray *restaurants, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        completion(restaurants, error);
    }];
}

- (void) filterRestaurants: (NSMutableArray *) restaurants byDistance: (double) filterDistance fromLocation: (CLLocation *) userLocation withCompletion: (void(^)(NSMutableArray *restaurants, NSMutableArray *filteredRestaurantIds))completion{
    
    NSMutableArray *filteredRestaurants = [[NSMutableArray alloc] init];
    NSMutableArray *filteredRestaurantIds = [[NSMutableArray alloc] init];
    
    
    for (Restaurant *restaurant in restaurants) {
        CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:[restaurant.latitude doubleValue] longitude:[restaurant.longitude doubleValue]];
        
        CLLocationDistance locationDistance = [restaurantLocation distanceFromLocation:userLocation];
        double distanceInMiles = locationDistance * 0.000621371;
        
        
        if (distanceInMiles <= filterDistance) {
            [filteredRestaurants addObject:restaurant];
            [filteredRestaurantIds addObject:restaurant.objectId];
        }
    }
    completion(filteredRestaurants, filteredRestaurantIds);
}

- (NSMutableArray *) getAllDishesInRestaurants: (NSMutableArray *) restaurants {
    NSMutableArray *dishes = [[NSMutableArray alloc] init];
    for (Restaurant *restaurant in restaurants) {
        [dishes addObjectsFromArray:restaurant.dishes];
    }
    return dishes;
}

- (void) getUsersPastPostsForRestaurants: (NSMutableArray *) restaurantIds withCompletion: (void(^)(NSArray *posts, NSError *error))completion {
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    
    [postQuery includeKey:@"dish"];
    [postQuery whereKey:@"author" equalTo:currentUser];
    
    PFQuery *dishQuery = [PFQuery queryWithClassName:@"Dish"];
    [dishQuery whereKey:@"restaurantID" containedIn:restaurantIds];
    [dishQuery includeKeys:@[@"avgRating", @"numCheckIns"]];
    
    [postQuery whereKey:@"dish" matchesQuery:dishQuery];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        completion(posts,error);
    }];
}

- (void) sortDishes: (NSMutableArray *) dishes withTasteImportance: (BOOL) taste {
    NSSortDescriptor *numCheckInsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numCheckIns"
                                                                              ascending:NO];
    NSSortDescriptor *ratingSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"avgRating"
                                                                         ascending:NO];
    
    NSMutableArray *sorts = [[NSMutableArray alloc] init];
    [sorts addObject:numCheckInsSortDescriptor];
    
    if (taste) {
        [sorts insertObject:ratingSortDescriptor atIndex:0];
    } else {
        [sorts addObject:ratingSortDescriptor];
    }
    
    [dishes sortUsingDescriptors:sorts];
    self.dish = dishes[0];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.dish = self.dish;
    }
}

@end
