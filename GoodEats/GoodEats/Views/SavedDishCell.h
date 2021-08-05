//
//  SavedDishCell.h
//  GoodEats
//
//  Created by Surbhi Jain on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface SavedDishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *dishImage;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reviewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar5;

@property (nonatomic, strong) Dish *dish;

@end

NS_ASSUME_NONNULL_END
