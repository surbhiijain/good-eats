//
//  APIManager.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#ifndef APIManager_h
#define APIManager_h
#import "Restaurant.h"

@interface APIManager : NSObject

+ (instancetype)shared;

- (void) fetchAllRestaurantsWithOrderKey: (NSString *) order
                             withLimit: (NSNumber *) limit
                       withConstraints: (NSDictionary *) constraints
                        withCompletion: (void(^)(NSMutableArray *restaurants, NSError *error))completion;

- (void) fetchRestaurantWithId: (NSString *) restaurantId
                withCompletion: (void(^)(Restaurant *restaurant, NSError *error))completion;

- (void) fetchAllPostsWithOrderKey:(NSString *) order
                         withLimit:(NSNumber *) limit
                        withAuthor:(PFUser *) author
                          withKeys:(NSArray *) keys
                   withRestaurants:(NSArray *) validRestaurantIds
                          withDish:(Dish *) dish
                withSecondaryOrder:(NSString *) secondaryOrder
                    withCompletion:(void(^)(NSMutableArray *posts, NSError *error))completion;

@end


#endif /* APIManager_h */
