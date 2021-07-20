//
//  Restaurant.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

@class Dish;
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *dishes;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *abrevLocation;
@property (nonatomic, strong) NSNumber *numCheckIns;

- (instancetype) initWithName:(NSString *)name withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withLocation:(NSString *) abrevLocation;
- (void) addDish:(Dish *)dish;
- (void) addCheckIn;

@end

NS_ASSUME_NONNULL_END

