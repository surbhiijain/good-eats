//
//  TableViewCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "FeedPostCell.h"
#import "Utils.h"

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
    
    PFUser *user = self.post.author;
    self.usernameLabel.text = user.username;
    self.restaurantLabel.text = self.post.dish.restaurantName;
  
    // set the post UIImageView based on the PFImage pased in through parse
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    [self.dishButton setTitle:self.post.dish.name forState:UIControlStateNormal];
    self.captionLabel.text = self.post.caption;
    
    [self setStars];
    [self setTags];

}

- (void)prepareForReuse {
    [super prepareForReuse];
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

- (void)setStars {
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    [Utils setStarFills:self.post.rating withStars:stars];
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
