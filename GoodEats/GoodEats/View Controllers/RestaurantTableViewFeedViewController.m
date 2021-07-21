//
//  RestaurantTableViewFeedViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "RestaurantTableViewFeedViewController.h"
#import "FeedPostCell.h"
#import "Post.h"

@interface RestaurantTableViewFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation RestaurantTableViewFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedPostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    cell.post = post;
    [cell refreshData];
    
    return cell;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
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
