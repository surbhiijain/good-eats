//
//  RestaurantSearchViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/2/21.
//

#import "RestaurantSearchViewController.h"
#import "APIManager.h"
#import "RestaurantSearchCell.h"
#import "LocationManager.h"

@interface RestaurantSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *filteredRestaurants;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) YLPCoordinate *userCoordinate;

@end

@implementation RestaurantSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setUpLocationManager];
}

- (void)LocationManager:(LocationManager *)locationManager
      setUpWithLocation:(CLLocation *)location {
    
    self.userCoordinate = [[YLPCoordinate alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredRestaurants = [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        return;
    }
    
    [[APIManager shared] fetchYelpRestaurantWithName:searchText withUserCoordinate:self.userCoordinate withCompletion:^(YLPSearch *search, NSError *error) {
        if (error || !search || !search.businesses.count) {
            self.filteredRestaurants = [[NSMutableArray alloc] init];
        } else {
            self.filteredRestaurants = (NSMutableArray *) search.businesses;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                             withObject:nil
                                          waitUntilDone:YES];
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantSearchCell"];
    
    cell.YLPRestaurant = self.filteredRestaurants[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredRestaurants.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLPBusiness *restaurant = self.filteredRestaurants[indexPath.row];
    [self.delegate RestaurantSearchViewController:self selectedRestaurant:restaurant];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
