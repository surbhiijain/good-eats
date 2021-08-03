//
//  DishAutocompleteCell.h
//  GoodEats
//
//  Created by Surbhi Jain on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface DishAutocompleteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;

@property(nonatomic, strong) Dish *dish;

@end

NS_ASSUME_NONNULL_END
