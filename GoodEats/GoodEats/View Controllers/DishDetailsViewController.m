//
//  DishDetailsViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/15/21.
//

#import "DishDetailsViewController.h"
#import "DishPostCell.h"
#import "Post.h"

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
    [query includeKeys:@[@"author",@"image"]];
    [query whereKey:@"dish" equalTo:self.dish];
    [query orderByDescending:@"createdAt"];
    query.limit = 25;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"got all the posts");
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

- (void) calculateAverageRating {
    NSNumber *sum = @0;
    for (Post *post in self.posts) {
        sum = @([sum doubleValue] + [post.rating doubleValue]);
    }
    NSNumber *avgRating = @([sum doubleValue] / self.posts.count);
    self.ratingLabel.text = [NSString stringWithFormat:@"Overall Rating: %@/5", [avgRating stringValue]];
    [self setRatingStarsWithRating:avgRating];
}

- (void) setRatingStarsWithRating: (NSNumber* ) rating {
    // round average rating to nearest 0.5
    float roundedRating = [rating floatValue] < 0.5f ? 0.5f : floorf([rating floatValue] * 2) / 2;

    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    UIImage *fill =  [UIImage systemImageNamed:@"star.fill"];
    UIImage *half = [UIImage systemImageNamed:@"star.leadinghalf.fill"];

    // fill one star at a time until you reach the rating value
    while (roundedRating > 0.0f) {
        UIImageView *star = stars[0];
        [stars removeObject:star];
        if (roundedRating == 0.5f) {
            [star setImage:half];
            roundedRating = 0.0f;
        } else {
            [star setImage:fill];
            roundedRating = roundedRating - 1.0f;
        }
        [star setTintColor:[UIColor systemYellowColor]];
    }
}

- (void) refreshData {
    [self calculateAverageRating];
    
    // calculate total number of checkins, accounting for how they may not have all been queried because the limit is 25
    NSString *numCheckIns = [@(self.posts.count) stringValue];
    if ([numCheckIns isEqualToString:@"25"]) {
        numCheckIns = @"25+";
    }
    self.numCheckInsLabel.text = [NSString stringWithFormat:@"%@ Total Check-Ins", numCheckIns];
    
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
