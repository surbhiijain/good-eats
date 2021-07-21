//
//  RestaurantDetailViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/20/21.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantPopularDishesViewController.h"

@interface RestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *popularView;
@property (weak, nonatomic) IBOutlet UIView *postsView;
@property (weak, nonatomic) IBOutlet UIView *gridView;

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCheckInsLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@property (nonatomic, strong) Restaurant *restaurant;


@end

@implementation RestaurantDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRestaurant];
}

- (void) getRestaurant {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query getObjectInBackgroundWithId:self.restaurantId block:^(PFObject *restaurant, NSError *error) {
        if (!error) {
            self.restaurant = (Restaurant *) restaurant;
            [self setHeaderValues];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void) setHeaderValues {
    self.restaurantNameLabel.text = self.restaurant.name;
    self.locationLabel.text = self.restaurant.abrevLocation;
    self.numCheckInsLabel.text = [NSString stringWithFormat:@"%@ Total Check-Ins", self.restaurant.numCheckIns];
}

- (IBAction)didChangeView:(UISegmentedControl *)segmentedControl {
    switch (self.segControl.selectedSegmentIndex) {
        case 0:
            self.popularView.hidden = false;
            self.postsView.hidden = true;
            self.gridView.hidden = true;
            break;
        case 1:
            self.postsView.hidden = false;
            self.popularView.hidden = true;
            self.gridView.hidden = true;
            break;
        case 2:
            self.gridView.hidden = false;
            self.popularView.hidden = true;
            self.postsView.hidden = true;
            
        default:
            break;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"restaurantPopularDishesSegue"]) {
        RestaurantPopularDishesViewController *popularDishesVC = [segue destinationViewController];
        popularDishesVC.restaurant = self.restaurant;
        popularDishesVC.restaurantId = self.restaurantId;
    }
    if ([segue.identifier isEqualToString:@"restaurantPostFeedSegue"]) {
        // TODO: pass restaurant
    }
}

@end
