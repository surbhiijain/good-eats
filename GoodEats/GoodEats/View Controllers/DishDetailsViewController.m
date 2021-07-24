//
//  DishDetailsViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/15/21.
//

#import "DishDetailsViewController.h"
#import "DishPostCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "RestaurantDetailViewController.h"
#import "Utils.h"

@interface DishDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dishLabel;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCheckInsLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@property (weak, nonatomic) IBOutlet UILabel *tagCountLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagCountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tagCountLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tagCountLabel4;
@property (weak, nonatomic) IBOutlet UILabel *tagCountLabel5;


@property (weak, nonatomic) IBOutlet UIImageView *reviewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar5;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation DishDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    self.dishLabel.text = self.dish.name;
    [self.restaurantButton setTitle:self.dish.restaurantName forState:UIControlStateNormal];
    
    [self getAllPostsofDish];
    
    [self.refreshControl addTarget:self action:@selector(getAllPostsofDish) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) getAllPostsofDish {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:@[@"author",@"image", @"dish"]];
    [query whereKey:@"dish" equalTo:self.dish];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self refreshData];
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
    DishPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DishPostCell"];
    
    Post *post = self.posts[indexPath.row];
    
    cell.post = post;
    [cell refreshData];
    
    return cell;
}

- (NSMutableDictionary *) getTagCounts {
    NSMutableDictionary *tagCounts = [NSMutableDictionary new];
    for (Post *post in self.posts) {
        for (NSString *tag in post.tags) {
            NSNumber *prevCount = @0;
            if ([tagCounts objectForKey:tag]) {
                prevCount = tagCounts[tag];
            }
            [tagCounts setObject:@([prevCount intValue] + [@1 intValue]) forKey:tag];
        }
    }
    
    return tagCounts;
}

- (void)setTags {
    
    NSMutableDictionary *tagCounts = [self getTagCounts];
    
    NSArray* sortedKeys = [tagCounts keysSortedByValueUsingComparator:^(NSNumber *first, NSNumber *second) {
        if ([first integerValue] > [second integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        
        if ([first integerValue] < [second integerValue])
            return (NSComparisonResult)NSOrderedDescending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *tagButtons = [[NSMutableArray alloc] init];
    [tagButtons addObject:self.tagButton1];
    [tagButtons addObject:self.tagButton2];
    [tagButtons addObject:self.tagButton3];
    [tagButtons addObject:self.tagButton4];
    [tagButtons addObject:self.tagButton5];
    
    NSMutableArray *tagLabels = [[NSMutableArray alloc] init];
    [tagLabels addObject:self.tagCountLabel1];
    [tagLabels addObject:self.tagCountLabel2];
    [tagLabels addObject:self.tagCountLabel3];
    [tagLabels addObject:self.tagCountLabel4];
    [tagLabels addObject:self.tagCountLabel5];
    
    int tagButtonIndex = 0;
    for (NSString *tagName in sortedKeys) {
        UIButton *tagButton = tagButtons[tagButtonIndex];
        UILabel *tagCountLabel = tagLabels[tagButtonIndex];
        tagButtonIndex += 1;
        NSNumber *count = tagCounts[tagName];
        [tagButton setTitle:tagName forState:UIControlStateNormal];
        tagCountLabel.text = [count stringValue];
    }
    
    for (int i = tagButtonIndex; i < tagButtons.count; i++) {
        UIButton *tagButton = tagButtons[i];
        UILabel *tagCountLabel = tagLabels[i];
        
        [tagButton setTitle:@"" forState:UIControlStateNormal];
        tagCountLabel.text = @"";
        [tagButton setHidden:TRUE];
    }
}

- (void) setRatingStars {
    self.ratingLabel.text = [NSString stringWithFormat:@"Overall Rating: %@/5", [self.dish.avgRating stringValue]];
    
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    [Utils setStarFills:self.dish.avgRating withStars:stars];
}

- (void) refreshData {
    [self setRatingStars];
    [self setTags];
    self.numCheckInsLabel.text = [NSString stringWithFormat:@"%@ Total Check-Ins", self.dish.numCheckIns];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Post *post = self.posts[indexPath.row];
    if ([segue.identifier isEqualToString:@"postDetailsSegue"]) {
        PostDetailViewController *detailsVC = [segue destinationViewController];
        detailsVC.post = post;
    } else if ([segue.identifier isEqualToString:@"restaurantDetailsSegue"]) {
        RestaurantDetailViewController *restaurantDetailsVC = [segue destinationViewController];
        restaurantDetailsVC.restaurantId = post.dish.restaurantID;
    }
}

@end
