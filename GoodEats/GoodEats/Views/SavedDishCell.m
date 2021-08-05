//
//  SavedDishCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/5/21.
//

#import "SavedDishCell.h"
#import "APIManager.h"
#import "Utils.h"
#import "Post.h"

@implementation SavedDishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDish:(Dish *)dish {
    _dish = dish;
    
    self.dishNameLabel.text = self.dish.name;
    self.restaurantNameLabel.text = self.dish.restaurantName;
    
    [self setStars];
    [self setDishImageView];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    UIImage *star =  [UIImage systemImageNamed:@"star"];
    
    [self.reviewStar1 setImage:star];
    [self.reviewStar2 setImage:star];
    [self.reviewStar3 setImage:star];
    [self.reviewStar4 setImage:star];
    [self.reviewStar5 setImage:star];
    
    [self.dishImage setImage:nil];
}

- (void)setStars {
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    [stars addObject:self.reviewStar1];
    [stars addObject:self.reviewStar2];
    [stars addObject:self.reviewStar3];
    [stars addObject:self.reviewStar4];
    [stars addObject:self.reviewStar5];
    
    [Utils setStarFills:self.dish.avgRating withStars:stars];
}

- (void) setDishImageView {
    
    [[APIManager shared] fetchAllPostsWithOrderKey:@"createdAt"
                                         withLimit:@1 withAuthor:nil
                                          withKeys:@[@"image"]
                                   withRestaurants:nil
                                          withDish:self.dish
                                withSecondaryOrder:nil
                                    withCompletion:^(NSMutableArray *posts, NSError *error) {
        if (posts) {
            Post *post = posts[0];
            [post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.dishImage setImage:image] ;
            }];
        }
    }];
}

@end
