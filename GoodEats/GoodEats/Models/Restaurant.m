//
//  Restaurant.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Restaurant.h"

@implementation Restaurant

@dynamic restaurantID;
@dynamic name;
@dynamic posts;
@dynamic dishes;
@dynamic latitude;
@dynamic longitude;

+ (nonnull NSString *)parseClassName {
    return @"Restaurant";
}

@end
