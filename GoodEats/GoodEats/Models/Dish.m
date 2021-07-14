//
//  Dish.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Dish.h"
#import "Restaurant.h"

@implementation Dish

@dynamic dishID;
@dynamic name;
@dynamic restaurantName;

+ (nonnull NSString *)parseClassName {
    return @"Dish";
}

- (instancetype)initWithName:(NSString *)name withRestaurant:(NSString *)restaurant {
    if (self = [super init]) {
        self.name = name;
        self.restaurantName = restaurant;
    }
    return self;
}

@end
