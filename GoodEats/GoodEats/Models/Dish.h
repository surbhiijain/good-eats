//
//  Dish.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

@class Restaurant;
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dish : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSNumber *numCheckIns;
@property (nonatomic, strong) NSNumber *avgRating;

- (instancetype)initWithName:(NSString *)name
              withRestaurant:(NSString *)restaurantName
            withRestaurantID: (NSString *)restaurantID;

- (void) addCheckInWithRating: (NSNumber *) rating;

@end

NS_ASSUME_NONNULL_END
