//
//  MapViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "ComposeViewController.h"
#import "RestaurantDetailViewController.h"
#import "TableFeedViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) LocationManager *locationManager;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
    
    self.tabBarController.delegate = self;
    
    self.mapView.delegate = self;
    
    [self getAllRestaurants];
}

- (void)LocationManager:(LocationManager *)locationManager setUpWithLocation:(CLLocation *)location {
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    
    [self.mapView setRegion:sfRegion animated:false];
    
    [self.mapView setShowsUserLocation:TRUE];
}

- (void)FilterViewController:(FilterViewController *)filterViewController reloadFeedWithRestaurants:(NSMutableArray *)restaurants {
    self.restaurants = restaurants;
    [self displayAllPinsForRestaurantArray:restaurants];
}

- (void) getAllRestaurants {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKeys:@[@"dishes"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        if (restaurants != nil) {
            self.restaurants = (NSMutableArray *) restaurants;
            [self displayAllPinsForRestaurantArray:restaurants];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) displayPinForRestaurant: (Restaurant *) restaurant {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(restaurant.latitude.floatValue, restaurant.longitude.floatValue);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = restaurant.name;
    annotation.subtitle = restaurant.objectId;
    
    [self.mapView addAnnotation:annotation];
}

- (void) displayAllPinsForRestaurantArray: (NSArray *) restaurants {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (Restaurant *restaurant in restaurants) {
        [self displayPinForRestaurant:restaurant];
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.restaurantId = view.annotation.subtitle;
    [self performSegueWithIdentifier:@"restaurantDetailsSegue" sender:self];
}

- (void)ComposeViewController:(ComposeViewController *)controller postedRestaurant:(Restaurant *)restaurant {
    [self.restaurants addObject:restaurant];
    [self displayPinForRestaurant:restaurant];
}

// find and set compose view controller delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *viewControllers = (UINavigationController *) viewController;
        for (id vc in viewControllers.viewControllers) {
            if ([vc isKindOfClass:[ComposeViewController class]]) {
                ComposeViewController *composeViewController = (ComposeViewController *) vc;
                composeViewController.delegate = self;
            }
        }
    }
}
- (IBAction)didTapToNavigateToTableFeed:(id)sender {
    [self performSegueWithIdentifier:@"tableFeedSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"restaurantDetailsSegue"]) {
        RestaurantDetailViewController *restaurantDetailsVC = [segue destinationViewController];
        restaurantDetailsVC.restaurantId = self.restaurantId;
    } if ([segue.identifier isEqualToString:@"filterSegue"]) {
        UINavigationController *navigationVC = [segue destinationViewController];
        FilterViewController *filterVC = (FilterViewController *) navigationVC.topViewController;
        filterVC.delegate = self;
    } if ([segue.identifier isEqualToString:@"tableFeedSegue"]) {
        TableFeedViewController *tableFeedVC = [segue destinationViewController];
        // TODO: add some properties to tableFeedVC to help with filtering
    }
}

@end
