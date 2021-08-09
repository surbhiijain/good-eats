//
//  RestaurantSearchCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 8/2/21.
//

#import "RestaurantSearchCell.h"
#import <YelpAPI/YLPLocation.h>

@implementation RestaurantSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setYLPRestaurant:(YLPBusiness *)YLPRestaurant {
    _YLPRestaurant = YLPRestaurant;
    
    self.nameLabel.text = YLPRestaurant.name;
    if (YLPRestaurant.location.address && YLPRestaurant.location.address.count) {
        self.addressLabel.text = YLPRestaurant.location.address[0];
    }
}

@end
