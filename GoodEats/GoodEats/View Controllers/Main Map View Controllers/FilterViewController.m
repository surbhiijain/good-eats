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
#import "Post.h"
#import "APIManager.h"

@interface FilterViewController () <LocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegControl;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) NSMutableArray *restaurantIds;


@property (nonatomic, strong) NSMutableArray *tags;


@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
    
    self.restaurants = [[NSMutableArray alloc] init];
    self.restaurantIds = [[NSMutableArray alloc] init];
    
    self.tags = [[NSMutableArray alloc] init];
    
    
}
- (IBAction)didApplyFilters:(UIButton *)sender {
    
    [[APIManager shared] fetchAllRestaurantsWithOrderKey:@"createdAt"
                                             withLimit:@25
                                       withConstraints:nil
                                        withCompletion:^(NSMutableArray *restaurants, NSError *error) {

        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        self.restaurants = (NSMutableArray *) restaurants;
        double filterDistance = [self getFilteredDistance];
        if (filterDistance) {
            [self filterRestaurantsByDistance:filterDistance fromLocation:self.userLocation];
        }
        if (self.tags.count > 0) {
            [self filterRestaurants:self.restaurants ByTags:self.tags];
        }
        [self.delegate FilterViewController:self reloadFeedWithRestaurants:self.restaurants withRestaurantIds:self.restaurantIds];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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

- (void) LocationManager:(LocationManager *)locationManager
      setUpWithLocation:(CLLocation *)location {
    self.userLocation = location;
}

- (void) filterRestaurantsByDistance:(double) filterDistance
                        fromLocation:(CLLocation *) userLocation {
    
    NSMutableArray *filteredRestaurants = [[NSMutableArray alloc] init];
    NSMutableArray *filteredRestaurantIds = [[NSMutableArray alloc] init];
    
    for (Restaurant *restaurant in self.restaurants) {
        CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:[restaurant.latitude doubleValue] longitude:[restaurant.longitude doubleValue]];
        
        CLLocationDistance locationDistance = [restaurantLocation distanceFromLocation:userLocation];
        double distanceInMiles = locationDistance * 0.000621371;
        
        
        if (distanceInMiles <= filterDistance) {
            [filteredRestaurants addObject:restaurant];
            [filteredRestaurantIds addObject:restaurant.objectId];
        }
    }
    self.restaurants = filteredRestaurants;
    self.restaurantIds = filteredRestaurantIds;
}

- (void) filterRestaurants:(NSArray *) restaurants
                    ByTags:(NSArray *) tags {
    
    NSMutableArray *filteredRestaurants = [[NSMutableArray alloc] init];
    NSMutableArray *filteredRestaurantIds = [[NSMutableArray alloc] init];

    
    for (Restaurant *restaurant in restaurants) {
        
        for (Dish *dish in restaurant.dishes) {
            
            [self getAllPostsWithDish:dish withCompletion:^(NSArray *posts, NSError *error) {
                
                NSMutableDictionary *tagCounts = [self getTagCountsforTags:tags withPosts:posts];
                BOOL valid = [self findIfRestaurantMeetsFilterWithTags:tags withTagCounts:tagCounts forDish:dish];
                
                if (valid) {
                    [filteredRestaurants addObject:restaurant];
                    [filteredRestaurantIds addObject:restaurant.objectId];
                }
                
                self.restaurants = filteredRestaurants;
                self.restaurantIds = filteredRestaurantIds;
                
                [self.delegate FilterViewController:self reloadFeedWithRestaurants:self.restaurants withRestaurantIds:self.restaurantIds];
            }];
        }
    }
}

- (void) getAllPostsWithDish:(Dish *) dish
              withCompletion:(void(^)(NSArray *posts, NSError *error))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:@[@"tags"]];
    [query whereKey:@"dish" equalTo:dish];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        completion(posts,error);
    }];
}

- (NSMutableDictionary *) getTagCountsforTags: (NSArray *) tags withPosts: (NSArray *) posts {
    NSMutableDictionary *tagCounts = [NSMutableDictionary new];
    for (Post *post in posts) {
        for (NSString *tag in post.tags) {
            if (![tags containsObject:tag]) {
                continue;
            }
            NSNumber *prevCount = [tagCounts objectForKey:tag] ? tagCounts[tag] : @0;
            [tagCounts setObject:@([prevCount intValue] + [@1 intValue]) forKey:tag];
        }
    }
    return tagCounts;
}

- (BOOL) findIfRestaurantMeetsFilterWithTags:(NSArray *) tags
                               withTagCounts:(NSMutableDictionary *) tagCounts
                                     forDish:(Dish *) dish {
    for (NSString *tag in tags) {
        if (!([tagCounts objectForKey:tag] && tagCounts[tag] >= @([dish.numCheckIns doubleValue] / 2))) {
            return FALSE;
        }
    }
    return TRUE;
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

@end
