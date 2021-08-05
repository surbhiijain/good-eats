//
//  Dish.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Dish.h"
#import "Restaurant.h"

@implementation Dish

@dynamic name;
@dynamic restaurantName;
@dynamic restaurantID;
@dynamic numCheckIns;
@dynamic avgRating;
@dynamic saves;

+ (nonnull NSString *)parseClassName {
    return @"Dish";
}

- (instancetype)initWithName:(NSString *)name
              withRestaurant:(NSString *)restaurantName
            withRestaurantID: (NSString *)restaurantID {
    
    if (self = [super init]) {
        self.name = name;
        self.restaurantName = restaurantName;
        self.restaurantID = restaurantID;
        self.numCheckIns = @0;
        self.avgRating = @0;
        self.saves = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCheckInWithRating:(NSNumber *)rating {
    
    NSNumber *ratingSumSoFar = @([self.numCheckIns doubleValue] * [self.avgRating doubleValue] + [rating doubleValue]);
    
    self.numCheckIns = @([self.numCheckIns intValue] + [@1 intValue]);
    self.avgRating = @([ratingSumSoFar doubleValue] / [self.numCheckIns doubleValue]);
    
    [self saveInBackground];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        Dish *otherDish = (Dish *) other;
        return [self.objectId isEqualToString:otherDish.objectId];
    }
}

- (NSUInteger)hash
{
    return [self.objectId hash];
}
@end
