//
//  MapViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "ComposeViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *restaurants;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setting initial visible region of map to SF
    // todo: change to user's current location
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(47.697631726141275, -122.02136993408205), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
    self.mapView.delegate = self;
    self.tabBarController.delegate = self;
    
    [self getAllRestaurants];
}

- (void) getAllRestaurants {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKeys:@[@"dishes"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        if (restaurants != nil) {
            self.restaurants = (NSMutableArray *) restaurants;
            for (Restaurant *restaurant in restaurants) {
                [self displayPin:restaurant];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) displayPin: (Restaurant *) restaurant {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(restaurant.latitude.floatValue, restaurant.longitude.floatValue);

    [self.navigationController popViewControllerAnimated:YES];
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = restaurant.name;
    [self.mapView addAnnotation:annotation];
}

- (void)ComposeViewController:(ComposeViewController *)controller postedRestaurant:(Restaurant *)restaurant {
    [self.restaurants addObject:restaurant];
    [self displayPin:restaurant];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
