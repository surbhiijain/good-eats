//
//  DishAutocompleteCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/3/21.
//

#import "DishAutocompleteCell.h"

@interface DishAutocompleteCell ()

@end

@implementation DishAutocompleteCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDish:(Dish *)dish {
    
    _dish = dish;
    self.dishNameLabel.text = dish.name;
}


@end
