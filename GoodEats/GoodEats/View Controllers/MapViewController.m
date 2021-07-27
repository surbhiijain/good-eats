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

@property (nonatomic, strong) TableFeedViewController *modalTableFeedViewController;

@property (nonatomic) CGFloat modalCardHeight;
@property (nonatomic) CGFloat modalCardHandleAreaHeight;

@property (nonatomic) BOOL cardVisible;

@property (nonatomic, strong) NSMutableArray *runningAnimations;
@property (nonatomic) CGFloat animationProgressWhenInterrupted;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
    
    self.tabBarController.delegate = self;
    
    self.mapView.delegate = self;
    
    [self setupModalCard];
    
    [self getAllRestaurants];
}

- (void) setupModalCard {
    self.modalCardHeight = 650;
    self.modalCardHandleAreaHeight = 150;
    self.animationProgressWhenInterrupted = 0;
    
    self.runningAnimations = [[NSMutableArray alloc] init];
    
    self.cardVisible = FALSE;
       
    self.modalTableFeedViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableFeedViewController"];
    [self addChildViewController:self.modalTableFeedViewController];
    [self.view addSubview:self.modalTableFeedViewController.view];
    
    self.modalTableFeedViewController.view.frame = CGRectMake(0, self.view.bounds.size.height - self.modalCardHandleAreaHeight, self.view.bounds.size.width, self.modalCardHeight);
    
    self.modalTableFeedViewController.view.clipsToBounds = TRUE;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardPan:)];
    
    [self.modalTableFeedViewController.handleArea addGestureRecognizer:self.tapGestureRecognizer];
    [self.modalTableFeedViewController.handleArea addGestureRecognizer:self.panGestureRecognizer];
    
}

- (void) handleCardTap: (UITapGestureRecognizer *) recognizer {
    [self animateTransitionIfNeededWithDuration:0.9];
}

- (void) handleCardPan: (UIPanGestureRecognizer *) recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self startInteractiveTransitionWithDuration:0.9];
            
        case UIGestureRecognizerStateChanged:
            [recognizer translationInView:(self.modalTableFeedViewController.handleArea)];
            
            CGPoint translatedPoint =  [recognizer translationInView:(self.modalTableFeedViewController.handleArea)];
            double fracComplete = translatedPoint.y / self.modalCardHeight;
            fracComplete = self.cardVisible ? fracComplete : - fracComplete;
            
            [self updateInteractiveTransition:fracComplete];
            
        case UIGestureRecognizerStateEnded:
            [self continueInteractiveTransition];
            
        default:
            break;
    }
}

- (void) animateTransitionIfNeededWithDuration: (double) duration {
    if (!(self.runningAnimations.count)) {
        UIViewPropertyAnimator *frameAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:1 animations:^{
            if (self.cardVisible) {
                self.modalTableFeedViewController.view.frame = CGRectMake(0, self.view.bounds.size.height - self.modalCardHandleAreaHeight, self.view.bounds.size.width, self.modalCardHeight);

            } else {
                self.modalTableFeedViewController.view.frame = CGRectMake(0, self.view.bounds.size.height - self.modalCardHeight, self.view.bounds.size.width, self.modalCardHeight);

            }
        }];
        
        [frameAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            self.cardVisible = !self.cardVisible;
            [self.runningAnimations removeAllObjects];
        }];
        
        [frameAnimator startAnimation];
        [self.runningAnimations addObject:frameAnimator];
    }
}

- (void) startInteractiveTransitionWithDuration: (double) duration {
    if (!(self.runningAnimations.count)) {
        [self animateTransitionIfNeededWithDuration:duration];
    }
}

- (void) updateInteractiveTransition: (CGFloat) fractionCompleted {
    for (UIViewPropertyAnimator *animator in self.runningAnimations) {
        animator.fractionComplete = fractionCompleted + self.animationProgressWhenInterrupted;
    }
}

- (void) continueInteractiveTransition {
    for (UIViewPropertyAnimator *animator in self.runningAnimations) {
        [animator continueAnimationWithTimingParameters:nil durationFactor:0];
    }
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"restaurantDetailsSegue"]) {
        RestaurantDetailViewController *restaurantDetailsVC = [segue destinationViewController];
        restaurantDetailsVC.restaurantId = self.restaurantId;
    } if ([segue.identifier isEqualToString:@"filterSegue"]) {
        UINavigationController *navigationVC = [segue destinationViewController];
        FilterViewController *filterVC = (FilterViewController *) navigationVC.topViewController;
        filterVC.delegate = self;
    }
}

@end
