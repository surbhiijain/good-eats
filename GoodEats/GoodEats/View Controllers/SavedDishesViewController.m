//
//  SavedDishesViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/5/21.
//

#import "SavedDishesViewController.h"
#import "SavedDishCell.h"
#import "APIManager.h"

@interface SavedDishesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dishes;

@end

@implementation SavedDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    PFUser *currUser = [PFUser currentUser];
    self.dishes = currUser[@"savedDishes"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SavedDishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedDishCell"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Dish"];
    [query getObjectInBackgroundWithId:self.dishes[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.dish = (Dish *) object;
    }];
    return cell;
}

@end
