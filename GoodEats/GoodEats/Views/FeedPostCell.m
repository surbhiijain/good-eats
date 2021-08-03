//
//  TableViewCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "FeedPostCell.h"
#import "Utils.h"
#import "APIManager.h"
#import <ChameleonFramework/Chameleon.h>

@implementation FeedPostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPost:(Post *)post {
    
    _post = post;
            
    PFUser *user = post.author;
    self.usernameLabel.text = user.username;
    [self.restaurantButton setTitle:post.dish.restaurantName forState:UIControlStateNormal];
  
    [post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
    
    PFFileObject *profilePic = user[@"image"];
    if (profilePic) {
        [profilePic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            [self.profileImage setImage:profileImage];
        }];
    }
    
    [self.dishButton setTitle:post.dish.name forState:UIControlStateNormal];
    self.captionLabel.text = post.caption;
    
    [self setStars];
    [self setTags];

}
- (IBAction)didTapRestaurant:(UIButton *)sender {
    
    [[APIManager shared] fetchRestaurantWithId:self.post.dish.restaurantID withCompletion:^(Restaurant *restaurant, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        self.restaurant = restaurant;
        [self.delegate callRestaurantSegueFromCell:self];
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.postImage setImage:nil];
    
    UIImage *image = [UIImage systemImageNamed:@"person.circle.filled"];
    [self.profileImage setImage:image];
    [self.profileImage setBackgroundColor:nil];
    [self.profileImage setTintColor:FlatTeal];

    self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.width / 2;
    
    self.usernameLabel.text = @"";
    [self.restaurantButton setTitle:@"" forState:UIControlStateNormal];
    [self.restaurantButton setBackgroundColor:nil];
    [self.restaurantButton setTitleColor:FlatTeal forState:UIControlStateNormal];
    
    self.captionLabel.text = @"";
    
    [self.dishButton setTitle:@"" forState:UIControlStateNormal];
    [self.dishButton setBackgroundColor:FlatWatermelon];
    
    UIImage *star =  [UIImage systemImageNamed:@"star"];
    
    [self.reviewStar1 setImage:star];
    [self.reviewStar2 setImage:star];
    [self.reviewStar3 setImage:star];
    [self.reviewStar4 setImage:star];
    [self.reviewStar5 setImage:star];
    
    [self.tagButton1 setHidden:FALSE];
    [self.tagButton2 setHidden:FALSE];
    [self.tagButton3 setHidden:FALSE];
    [self.tagButton4 setHidden:FALSE];
    [self.tagButton5 setHidden:FALSE];

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
