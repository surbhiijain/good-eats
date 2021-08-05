//
//  DishPostCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/15/21.
//

#import "DishPostCell.h"
#import "DateTools.h"
#import "Utils.h"
#import <ChameleonFramework/Chameleon.h>

@implementation DishPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPost:(Post *)post {

    _post = post;
    
    PFUser *user = self.post.author;
    self.usernameLabel.text = user.username;
  
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    PFFileObject *profilePic = user[@"image"];
    if (profilePic) {
        [profilePic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            [self.profileImage setImage:profileImage forState:UIControlStateNormal];
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;

        }];
    }
    
    self.captionLabel.text = self.post.caption;
    
    NSDate *timeNow = [NSDate date];
    NSInteger seconds = [timeNow secondsFrom:self.post.createdAt];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    self.timeStampLabel.text = timeDate.timeAgoSinceNow;
    
    [self setStarFills];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.postImage setImage:nil];

    UIImage *image = [UIImage systemImageNamed:@"person.circle.filled"];
    [self.profileImage setImage:image forState:UIControlStateNormal];
    [self.profileImage setBackgroundColor:nil];
    [self.profileImage setTintColor:FlatTeal];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    
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
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    [Utils setStarFills:self.post.rating withStars:stars];
}

@end
