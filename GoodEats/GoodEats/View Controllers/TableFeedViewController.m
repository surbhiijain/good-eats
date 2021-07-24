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

@interface TableFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TableFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self getAllPosts];
    
    [self.refreshControl addTarget:self action:@selector(getAllPosts) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) getAllPosts {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:@[@"author",@"image", @"dish"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
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
    [cell refreshData];
    
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"postDetailsSegue"]) {
        PostDetailViewController *detailsVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        detailsVC.post = self.posts[indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        FeedPostCell* cell = (FeedPostCell*)[[sender superview] superview];
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        Post *post = self.posts[indexPath.row];
        detailsVC.dish = post.dish;
    }
}

@end
