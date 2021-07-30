//
//  PopularDishCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "PopularDishCell.h"
#import "Utils.h"
#import "Post.h"

@implementation PopularDishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDish:(Dish *)dish {
    
    _dish = dish;
  
    self.dishNameLabel.text = self.dish.name;
    self.numCheckInsLabel.text = [NSString stringWithFormat:@"%@ check ins", self.dish.numCheckIns];
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
    [self getDishImageWithCompletion:^(NSArray *posts, NSError *error) {
        if (posts) {
            Post *post = posts[0];
            [post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.dishImageView setImage:image] ;
            }];
        }
    }];
}

- (void)getDishImageWithCompletion:(void(^)(NSArray *posts, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 1;
    [query includeKey:@"image"];
    [query whereKey:@"dish" equalTo:self.dish];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(objects, error);
    }];
}

@end
