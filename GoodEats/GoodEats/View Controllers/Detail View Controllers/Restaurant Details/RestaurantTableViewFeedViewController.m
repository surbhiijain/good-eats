//
//  RestaurantTableViewFeedViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "RestaurantTableViewFeedViewController.h"
#import "FeedPostCell.h"
#import "Post.h"
#import "APIManager.h"

@interface RestaurantTableViewFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation RestaurantTableViewFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getPosts];
}


- (void) getPosts {
    
    [[APIManager shared] fetchAllPostsWithOrderKey:@"createdAt"
                                         withLimit:self.restaurant.numCheckIns
                                        withAuthor:nil
                                          withKeys:@[@"image", @"dish", @"author"]
                                   withRestaurants:@[self.restaurant.objectId]
                                          withDish:nil
                                withSecondaryOrder:nil
                                    withCompletion:^(NSMutableArray *posts, NSError *error) {
        if (error) {
            NSLog(@"Error getting posts: %@", error);
        } else {
            self.posts = (NSMutableArray *) posts;
        }
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedPostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    cell.post = post;
    
    return cell;}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
