//
//  APIManager.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#ifndef APIManager_h
#define APIManager_h

@interface APIManager : NSObject

+ (instancetype)shared;

- (void) fetchAllRestaurantsWithOrderKey: (NSString *) order
                             withLimit: (NSNumber *) limit
                       withConstraints: (NSDictionary *) constraints
                        withCompletion: (void(^)(NSMutableArray *restaurants, NSError *error))completion;


@end


#endif /* APIManager_h */
