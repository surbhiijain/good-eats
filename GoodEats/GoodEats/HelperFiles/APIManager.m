//
//  APIManager.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "Parse/Parse.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) fetchAllRestaurantsWithOrderKey: (NSString *) order
                             withLimit: (NSNumber *) limit
                       withConstraints: (NSDictionary *) constraints
                        withCompletion: (void(^)(NSMutableArray *restaurants, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    if (order) {
        [query orderByDescending:order];
    }
    if (limit) {
        query.limit = [limit intValue];
    }
    if (constraints) {
        for (id key in constraints) {
            [query whereKey:key equalTo:[constraints objectForKey:key]];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        completion((NSMutableArray *) restaurants, error);
    }];
}

- (void) fetchRestaurantWithId: (NSString *) restaurantId
withCompletion: (void(^)(Restaurant *restaurant, NSError *error))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    [query getObjectInBackgroundWithId:restaurantId block:^(PFObject *object, NSError *error) {
        completion((Restaurant *) object, error);
    }];
}

@end
