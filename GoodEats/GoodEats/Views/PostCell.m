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
    
    [self.post.dish.restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.restaurantLabel.text = self.post.dish.restaurant.name;
    }];
  
    // set the post UIImageView based on the PFImage pased in through parse
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    self.captionLabel.text = self.post.caption;
    
    self.restaurantLabel.text = nil;

}

- (void)setPlaceholdersToNil {
    [self.postImage setImage:nil];
//    [self.profileImage setImage:nil];
    
    self.usernameLabel.text = @"";
    self.restaurantLabel.text = @"";
    self.captionLabel.text = @"";
}

@end
