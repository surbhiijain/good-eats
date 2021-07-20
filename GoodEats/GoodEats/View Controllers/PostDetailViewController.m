//
//  PostDetailViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/14/21.
//

#import "PostDetailViewController.h"
#import "DateTools.h"
#import "DishDetailsViewController.h"
#import "RestaurantDetailViewController.h"

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIButton *restaurantLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *dishButton;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reviewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar5;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    // Do any additional setup after loading the view.
}

- (void)refreshData {
    [self setPlaceholdersToNil];
    
    PFUser *user = self.post.author;
    self.usernameLabel.text = user.username;
    
    [self.restaurantLabel setTitle:self.post.dish.restaurantName forState:(UIControlStateNormal)];
    // get restaurant to display location
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query getObjectInBackgroundWithId:self.post.dish.restaurantID block:^(PFObject *restaurant, NSError *error) {
        if (!error) {
            Restaurant *r = (Restaurant *) restaurant;
            self.locationLabel.text = r.abrevLocation;
        } else {
            self.locationLabel.hidden = TRUE;
        }
    }];
    
    // set the post UIImageView based on the PFImage pased in through parse
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    [self.dishButton setTitle:self.post.dish.name forState:UIControlStateNormal];
    self.captionLabel.text = self.post.caption;
    
    // use DateTools pod to add time ago feature
    NSDate *timeNow = [NSDate date];
    NSInteger seconds = [timeNow secondsFrom:self.post.createdAt];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    self.timeStampLabel.text = timeDate.timeAgoSinceNow;
    
    [self setStarFills];
    [self setTags];

}

- (void)setPlaceholdersToNil {
    [self.postImage setImage:nil];
//    [self.profileImage setImage:nil];
    
    self.usernameLabel.text = @"";
    [self.restaurantLabel setTitle:@"" forState:(UIControlStateNormal)];
    self.captionLabel.text = @"";
    [self.dishButton setTitle:@"" forState:UIControlStateNormal];
    
    UIImage *star =  [UIImage systemImageNamed:@"star"];
    
    [self.reviewStar1 setImage:star];
    [self.reviewStar2 setImage:star];
    [self.reviewStar3 setImage:star];
    [self.reviewStar4 setImage:star];
    [self.reviewStar5 setImage:star];
}

- (void)setStarFills {
    NSNumber *rating = self.post.rating;
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    UIImage *fill =  [UIImage systemImageNamed:@"star.fill"];
    UIImage *half = [UIImage systemImageNamed:@"star.leadinghalf.fill"];

    // fill one star at a time until you reach the rating value
    while ([rating doubleValue] > [@0 doubleValue]) {
        UIImageView *star = stars[0];
        [stars removeObject:star];
        if ([rating isEqualToNumber:@.5]) {
            [star setImage:half];
            rating = @0;
        } else {
            [star setImage:fill];
            rating = @([rating doubleValue] + [@-1 doubleValue]);
        }
        [star setTintColor:[UIColor systemYellowColor]];
    }
}


- (void)setTags {
    NSMutableArray *tagButtons = [[NSMutableArray alloc] init];
    [tagButtons addObject:self.tagButton1];
    [tagButtons addObject:self.tagButton2];
    [tagButtons addObject:self.tagButton3];
    [tagButtons addObject:self.tagButton4];
    [tagButtons addObject:self.tagButton5];
        
    // display tags starting from bottom left until there are no more and hide any remaining tag placeholders
    for (int i = 0; i < tagButtons.count; i++) {
        UIButton *tagButton = tagButtons[i];
        if (i < self.post.tags.count) {
            [tagButton setTitle:self.post.tags[i] forState:UIControlStateNormal];
        } else {
            [tagButton setTitle:@"" forState:UIControlStateNormal];
            [tagButton setHidden:TRUE];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.dish = self.post.dish;
    } else if ([segue.identifier isEqualToString:@"restaurantDetailsSegue"]) {
        RestaurantDetailViewController *restaurantDetailsVC = [segue destinationViewController];
        restaurantDetailsVC.restaurantId = self.post.dish.restaurantID;
    }
}

@end
