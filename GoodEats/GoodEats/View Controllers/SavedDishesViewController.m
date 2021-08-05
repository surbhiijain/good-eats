//
//  SavedDishesViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/5/21.
//

#import "SavedDishesViewController.h"
#import "SavedDishCell.h"
#import "APIManager.h"
#import "DishDetailsViewController.h"

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"dishDetailsSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIContextualAction *unsave = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        PFUser *currentUser = [PFUser currentUser];
        NSString *dishId = self.dishes[indexPath.row];
        
        [self.dishes removeObject:dishId];
        [currentUser removeObject:dishId forKey:@"savedDishes"];
        [self.tableView reloadData];
        [currentUser saveInBackground];
        completionHandler(true);
    }];
    
    unsave.image  = [UIImage systemImageNamed:@"star.slash"];
    unsave.title = @"Unsave";
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[unsave]];
    
    return actions;
}

# pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        SavedDishCell *cell = (SavedDishCell *) sender;
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.dish = cell.dish;
    }
}

@end
