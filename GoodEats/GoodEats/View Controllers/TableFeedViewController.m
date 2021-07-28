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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:@[@"author",@"image", @"dish"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;

    PFQuery *dishQuery = [PFQuery queryWithClassName:@"Dish"];
    if (self.validRestaurantIds.count) {
        [dishQuery whereKey:@"restaurantID" containedIn:self.validRestaurantIds];
        [query whereKey:@"dish" matchesQuery:dishQuery];
    }
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedPostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    cell.post = post;
    cell.delegate = self;
    
    [cell refreshData];
    
    return cell;
}

- (void)callRestaurantSegueFromCell:(FeedPostCell *)cell {
    [self performSegueWithIdentifier:@"restaurantDetailsSegue" sender:cell];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"postDetailsSegue"]) {
        PostDetailViewController *postDetailsVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        postDetailsVC.post = self.posts[indexPath.row];
    }
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
