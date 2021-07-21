//
//  PopularDishCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "PopularDishCell.h"

@implementation PopularDishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData {
  
    self.dishNameLabel.text = self.dish.name;
    self.numCheckInsLabel.text = [NSString stringWithFormat:@"%@ check ins", self.dish.numCheckIns];
//    [self setStarFills];
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

//- (void)setStarFills {
//    NSNumber *rating = self.post.rating;
//    NSMutableArray *stars = [[NSMutableArray alloc] init];
//    [stars addObject:self.reviewStar1];
//    [stars addObject:self.reviewStar2];
//    [stars addObject:self.reviewStar3];
//    [stars addObject:self.reviewStar4];
//    [stars addObject:self.reviewStar5];
//
//    UIImage *fill =  [UIImage systemImageNamed:@"star.fill"];
//    UIImage *half = [UIImage systemImageNamed:@"star.leadinghalf.fill"];
//
//    // fill one star at a time until you reach the rating value
//    while ([rating doubleValue] > [@0 doubleValue]) {
//        UIImageView *star = stars[0];
//        [stars removeObject:star];
//        if ([rating isEqualToNumber:@.5]) {
//            [star setImage:half];
//            rating = @0;
//        } else {
//            [star setImage:fill];
//            rating = @([rating doubleValue] + [@-1 doubleValue]);
//        }
//        [star setTintColor:[UIColor systemYellowColor]];
//    }
//}

@end
