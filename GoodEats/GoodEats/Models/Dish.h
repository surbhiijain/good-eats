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

@property (nonatomic, strong) NSString *dishID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Restaurant *restaurant;

- (instancetype) initWithName:(NSString *)name withRestaurant:(Restaurant *)restaurant;

@end

NS_ASSUME_NONNULL_END
