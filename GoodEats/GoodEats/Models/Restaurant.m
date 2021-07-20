//
//  Restaurant.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Restaurant.h"
//#import "Dish.h"

@implementation Restaurant

@dynamic restaurantID;
@dynamic name;
@dynamic dishes;
@dynamic latitude;
@dynamic longitude;
@dynamic abrevLocation;

+ (nonnull NSString *)parseClassName {
    return @"Restaurant";
}

- (instancetype)initWithName:(NSString *)name withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withLocation:(NSString *)abrevLocation{
    if (self = [super init]) {
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.dishes = [[NSMutableArray alloc] init];
        self.abrevLocation = abrevLocation;
    }
    return self;
}

- (void)addDish:(Dish *)dish {
    [self addObject:dish forKey:@"dishes"];
    [self saveInBackground];
}

@end
