//
//  RestaurantPopularDishesViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "RestaurantPopularDishesViewController.h"
#import "PopularDishCell.h"

@interface RestaurantPopularDishesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sortedDishes;

@end

@implementation RestaurantPopularDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getRestaurant];
}

- (void) getRestaurant {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    [query getObjectInBackgroundWithId:self.restaurantId block:^(PFObject *restaurant, NSError *error) {
        if (!error) {
            self.restaurant = (Restaurant *) restaurant;
            [self sortDishesByPopularity];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularDishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularDishCell"];

    Dish *dish = self.sortedDishes[indexPath.row];

    cell.dish = dish;
    [cell refreshData];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedDishes.count;
}

- (void) sortDishesByPopularity {
    self.sortedDishes = self.restaurant.dishes;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numCheckIns"
                                               ascending:NO];
    self.sortedDishes = [self.restaurant.dishes sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
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
