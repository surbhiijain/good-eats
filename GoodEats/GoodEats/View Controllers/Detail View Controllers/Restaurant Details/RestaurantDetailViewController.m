//
//  RestaurantDetailViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/20/21.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantPopularDishesViewController.h"
#import "RestaurantTableViewFeedViewController.h"
#import "RestaurantCollectionFeedViewController.h"

@interface RestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *popularView;
@property (weak, nonatomic) IBOutlet UIView *postsView;
@property (weak, nonatomic) IBOutlet UIView *gridView;

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCheckInsLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@end

@implementation RestaurantDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeaderValues];
    [self didChangeView:nil];
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
- (IBAction)didTapDirections:(UIButton *)sender {
    NSString *directionsURL = [NSString stringWithFormat: @"http://maps.apple.com/?daddr=%@,%@", self.restaurant.latitude, self.restaurant.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionsURL] options:@{} completionHandler:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"restaurantPopularDishesSegue"]) {
        RestaurantPopularDishesViewController *popularDishesVC = [segue destinationViewController];
        popularDishesVC.restaurant = self.restaurant;
    }
    if ([segue.identifier isEqualToString:@"restaurantPostFeedSegue"]) {
        RestaurantTableViewFeedViewController *tableViewfeedVC = [segue destinationViewController];
        tableViewfeedVC.restaurant = self.restaurant;
    }
    if ([segue.identifier isEqualToString:@"restaurantCollectionFeedSegue"]) {
        RestaurantCollectionFeedViewController *collectionFeedVC = [segue destinationViewController];
        collectionFeedVC.restaurant = self.restaurant;
    }
}

@end
