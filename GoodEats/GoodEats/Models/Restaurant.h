//
//  Restaurant.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSArray *dishes;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

//todo: add location and dishes


@end

NS_ASSUME_NONNULL_END

