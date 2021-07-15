//
//  DishPostCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/15/21.
//

#import "DishPostCell.h"
#import "DateTools.h"

@implementation DishPostCell

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
  
    // set the post UIImageView based on the PFImage pased in through parse
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    self.captionLabel.text = self.post.caption;
    
    // use DateTools pod to add time ago feature
    NSDate *timeNow = [NSDate date];
    NSInteger seconds = [timeNow secondsFrom:self.post.createdAt];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    self.timeStampLabel.text = timeDate.timeAgoSinceNow;
    
    [self setStarFills];
}

- (void)setPlaceholdersToNil {
    [self.postImage setImage:nil];
//    [self.profileImage setImage:nil];
    
    self.usernameLabel.text = @"";
    self.captionLabel.text = @"";
    
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

@end
