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
@dynamic restaurantID;

+ (nonnull NSString *)parseClassName {
    return @"Dish";
}

- (instancetype)initWithName:(NSString *)name withRestaurant:(NSString *)restaurantName withRestaurantID: (NSString *)restaurantID {
    if (self = [super init]) {
        self.name = name;
        self.restaurantName = restaurantName;
        self.restaurantID = restaurantID;
    }
    return self;
}

@end
