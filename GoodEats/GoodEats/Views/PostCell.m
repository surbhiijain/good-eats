//
//  TableViewCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "PostCell.h"

@implementation PostCell

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

}

- (void)setPlaceholdersToNil {
    [self.postImage setImage:nil];
//    [self.profileImage setImage:nil];
    
    self.usernameLabel.text = @"";
    self.restaurantLabel.text = @"";
    self.captionLabel.text = @"";
    [self.dishButton setTitle:@"" forState:UIControlStateNormal];
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

@end
