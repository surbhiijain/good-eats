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
@dynamic numCheckIns;

+ (nonnull NSString *)parseClassName {
    return @"Dish";
}

- (instancetype)initWithName:(NSString *)name withRestaurant:(NSString *)restaurantName withRestaurantID: (NSString *)restaurantID {
    if (self = [super init]) {
        self.name = name;
        self.restaurantName = restaurantName;
        self.restaurantID = restaurantID;
        self.numCheckIns = @0;
    }
    return self;
}

- (void)addCheckIn {
    self.numCheckIns = @([self.numCheckIns intValue] + [@1 intValue]);
    [self saveInBackground];
}

@end
