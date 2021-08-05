//
//  TableFeedViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "TableFeedViewController.h"
#import "FeedPostCell.h"
#import "PostDetailViewController.h"
#import "DishDetailsViewController.h"
#import "RestaurantDetailViewController.h"
#import "APIManager.h"
#import <ChameleonFramework/Chameleon.h>
#import <Toast/Toast.h>

@interface TableFeedViewController () <UITableViewDelegate, UITableViewDataSource, FeedPostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) Restaurant *selectedRestaurant;

@end

@implementation TableFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self fetchPosts];
    
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchPosts {
    
    [[APIManager shared] fetchAllPostsWithOrderKey:@"createdAt"
                                         withLimit:@25
                                        withAuthor:nil
                                          withKeys:@[@"author",@"image", @"dish"]
                                   withRestaurants:self.validRestaurantIds
                                          withDish:nil
                                withSecondaryOrder:nil
                                    withCompletion:^(NSMutableArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedPostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    cell.post = post;
    cell.delegate = self;
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PFUser *currentUser = [PFUser currentUser];
    Post *post = self.posts[indexPath.row];
    NSString *dishId = post.dish.objectId;
    NSMutableArray *savedDishes = currentUser[@"savedDishes"];
    
    UIContextualAction *saveDish = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction* action, UIView* sourceView, void (^completionHandler)(BOOL)) {
        
        NSString *toastMessage;
        
        if ([savedDishes containsObject:dishId]) {
            toastMessage = [NSString stringWithFormat:@"%@ is already saved!",post.dish.name];
        } else {
            [currentUser addObject:dishId forKey:@"savedDishes"];
            [currentUser saveInBackground];
            toastMessage = [NSString stringWithFormat:@"Saved %@!",post.dish.name];
        }
        [self.view makeToast:toastMessage duration:2.0 position:CSToastPositionCenter style:nil];
        
        completionHandler(true);
    }];
    
    saveDish.image  = [UIImage systemImageNamed:@"star.circle"];
    saveDish.backgroundColor = FlatWatermelon;
    saveDish.title = [NSString stringWithFormat:@"Save %@",post.dish.name];
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[saveDish]];
    
    return actions;
}

- (void)callRestaurantSegueFromCell:(FeedPostCell *)cell {
    [self performSegueWithIdentifier:@"restaurantDetailsSegue" sender:cell];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *dishDetailsVC = [segue destinationViewController];
        FeedPostCell* cell = (FeedPostCell*)[[sender superview] superview];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        Post *post = self.posts[indexPath.row];
        dishDetailsVC.dish = post.dish;
    }
    if ([segue.identifier isEqualToString:@"restaurantDetailsSegue"]) {
        RestaurantDetailViewController *restaurantDetailsVC = [segue destinationViewController];
        FeedPostCell* cell = (FeedPostCell*) sender;
        restaurantDetailsVC.restaurant = cell.restaurant;
    }
}

@end
