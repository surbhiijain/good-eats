//
//  Dish.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Dish.h"

@implementation Dish

@dynamic dishID;
@dynamic name;
@dynamic posts;

+ (nonnull NSString *)parseClassName {
    return @"Dish";
}

@end
