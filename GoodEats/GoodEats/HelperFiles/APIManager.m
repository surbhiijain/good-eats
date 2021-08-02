//
//  APIManager.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "Parse/Parse.h"
#import <YelpAPI/YLPClient+Search.h>
#import <YelpAPI/YLPSortType.h>
#import <YelpAPI/YLPBusiness.h>
#import <YelpAPI/YLPQuery.h>
#import "AppDelegate.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) fetchAllRestaurantsWithOrderKey:(NSString *) order
                               withLimit:(NSNumber *) limit
                         withConstraints:(NSDictionary *) constraints
                          withCompletion:(void(^)(NSMutableArray *restaurants, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    if (order) {
        [query orderByDescending:order];
    }
    if (limit) {
        query.limit = [limit intValue];
    }
    for (id key in constraints) {
        [query whereKey:key equalTo:[constraints objectForKey:key]];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        completion((NSMutableArray *) restaurants, error);
    }];
}

- (void) fetchRestaurantWithId:(NSString *) restaurantId
                withCompletion:(void(^)(Restaurant *restaurant, NSError *error))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    [query getObjectInBackgroundWithId:restaurantId block:^(PFObject *object, NSError *error) {
        completion((Restaurant *) object, error);
    }];
}

- (void) fetchAllPostsWithOrderKey:(NSString *) order
                         withLimit:(NSNumber *) limit
                        withAuthor:(PFUser *) author
                          withKeys:(NSArray *) keys
                   withRestaurants:(NSArray *) validRestaurantIds
                          withDish:(Dish *) dish
                withSecondaryOrder:(NSString *) secondaryOrder
                    withCompletion:(void(^)(NSMutableArray *posts, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:keys];
    
    if (order) {
        [query orderByDescending:order];
    } if (secondaryOrder) {
        [query addDescendingOrder:secondaryOrder];
    } if (limit) {
        query.limit = [limit intValue];
    } if (author) {
        [query whereKey:@"author" equalTo:author];
    } if (dish) {
        [query whereKey:@"dish" equalTo:dish];
    } if (validRestaurantIds) {
        PFQuery *dishQuery = [PFQuery queryWithClassName:@"Dish"];
        [dishQuery whereKey:@"restaurantID" containedIn:validRestaurantIds];
        [dishQuery includeKeys:@[@"avgRating", @"numCheckIns"]];
        [query whereKey:@"dish" matchesQuery:dishQuery];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        completion((NSMutableArray *) posts, error);
    }];
}

- (void) fetchYelpRestaurantWithName: (NSString *) name withUserCoordinate: (YLPCoordinate *) userCoordinate withCompletion: (void(^)(YLPSearch * search, NSError * error)) completion {
    
    YLPQuery *query = [[YLPQuery alloc] initWithCoordinate:userCoordinate];
    query.limit = 5;
    query.offset = 0;
    [query setTerm:name];
    [query setSort:YLPSortTypeDistance];
    [query setCategoryFilter:@[@"restaurants"]];
    
    [[AppDelegate sharedClient] searchWithQuery:query completionHandler:completion];
}

@end
