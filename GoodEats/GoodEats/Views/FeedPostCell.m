//
//  TableViewCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "FeedPostCell.h"

@implementation FeedPostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData {
    [self setPlaceholdersToNil];
    
    PFUser *user = self.post.author;
    self.usernameLabel.text = user.username;
    
//    [self.post.dish.restaurantName fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.restaurantLabel.text = self.post.dish.restaurantName;
//    }];
  
    // set the post UIImageView based on the PFImage pased in through parse
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    [self.dishButton setTitle:self.post.dish.name forState:UIControlStateNormal];
    self.captionLabel.text = self.post.caption;
    
    [self setStarFills];
    [self setTags];

}

- (void)setPlaceholdersToNil {
    [self.postImage setImage:nil];
//    [self.profileImage setImage:nil];
    
    self.usernameLabel.text = @"";
    self.restaurantLabel.text = @"";
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

@end
