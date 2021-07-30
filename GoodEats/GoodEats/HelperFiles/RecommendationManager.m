//
//  RecommendationManager.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#import <Foundation/Foundation.h>
#import "RecommendationManager.h"
#import "Restaurant.h"
#import "Post.h"

@implementation RecommendationManager


+ (void) getRecommendedDishWithDist:(double) dist
                          withTaste:(BOOL) taste
                 withAdventureIndex:(int) adventureIndex
                    withUserLoation: (CLLocation *) userLocation
                     withCompletion:(void(^)(Dish *dish, NSString *noRecsErrorString))completion{
    
    __block NSMutableArray *allDishes = [[NSMutableArray alloc] init];
    __block NSMutableArray *userTriedDishes = [[NSMutableArray alloc] init];
    __block NSString *noRecsErrorString = @"";
    
    [self getAllRestaurantsWithCompletion:^(NSMutableArray *restaurants, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        [self filterRestaurants:restaurants
                     byDistance:dist
                   fromLocation:userLocation
                 withCompletion:^(NSMutableArray *filteredRestaurants, NSMutableArray *filteredRestaurantIds) {
            
            if (!filteredRestaurants.count) {
                noRecsErrorString = @"No restaurants found close enough to you. Please increase your time, or try again later";
                completion(nil, noRecsErrorString);
                return;
            }
            
            if (adventureIndex != 0) {
                allDishes = [self getAllDishesInRestaurants:filteredRestaurants];
            }
            
            if (adventureIndex == 1) {
                Dish *d = [self getTopDishWithDishes:allDishes withSortImportance:taste];
                completion(d, nil);
                return;
            }
            
            [self getUsersPastPostsForRestaurants:filteredRestaurantIds withCompletion:^(NSArray *posts, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    return;
                }
                if (!posts.count && adventureIndex == 0) {
                    noRecsErrorString = @"No 'safe' restaurants exist since you have never checked in to a restaurant before. Select 'advernturous' to find something new, or start checking into restaurants on your own first!";
                    completion(nil, noRecsErrorString);
                    return;
                }
                
                for (Post *post in posts) {
                    [userTriedDishes addObject:post.dish];
                }
                if (adventureIndex == 0) {
                    Dish *d = [self getTopDishWithDishes:userTriedDishes withSortImportance:taste];
                    completion(d, nil);
                    return;
                }
                                       
                NSMutableArray *userNotTriedDishes = [NSMutableArray arrayWithArray:allDishes];
                    [userNotTriedDishes removeObjectsInArray:userTriedDishes];
                Dish *d = [self getTopDishWithDishes:userNotTriedDishes withSortImportance:taste];
                if (!d) {
                    noRecsErrorString = @"You've tried all the dishes in our database! Tell your friends to check into new places or broaden your query.";
                    completion(nil, noRecsErrorString);
                    return;
                }
                completion(d, nil);
            }];
        }];
    }];
}

+ (void) getAllRestaurantsWithCompletion: (void(^)(NSMutableArray *restaurants, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Restaurant"];
    [query includeKey:@"dishes"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *restaurants, NSError *error) {
        completion((NSMutableArray *) restaurants, error);
    }];
}

+ (void) filterRestaurants:(NSMutableArray *) restaurants
                byDistance:(double) filterDistance
              fromLocation:(CLLocation *) userLocation
            withCompletion:(void(^)(NSMutableArray *restaurants, NSMutableArray *filteredRestaurantIds))completion{
    
    NSMutableArray *filteredRestaurants = [[NSMutableArray alloc] init];
    NSMutableArray *filteredRestaurantIds = [[NSMutableArray alloc] init];
    
    
    for (Restaurant *restaurant in restaurants) {
        CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:[restaurant.latitude doubleValue] longitude:[restaurant.longitude doubleValue]];
        
        CLLocationDistance locationDistance = [restaurantLocation distanceFromLocation:userLocation];
        double distanceInMiles = locationDistance * 0.000621371;
        
        
        if (distanceInMiles <= filterDistance) {
            [filteredRestaurants addObject:restaurant];
            [filteredRestaurantIds addObject:restaurant.objectId];
        }
    }
    completion(filteredRestaurants, filteredRestaurantIds);
}

+ (NSMutableArray *) getAllDishesInRestaurants: (NSMutableArray *) restaurants {
    NSMutableArray *dishes = [[NSMutableArray alloc] init];
    for (Restaurant *restaurant in restaurants) {
        [dishes addObjectsFromArray:restaurant.dishes];
    }
    return dishes;
}

+ (void) getUsersPastPostsForRestaurants:(NSMutableArray *) restaurantIds
                          withCompletion:(void(^)(NSArray *posts, NSError *error))completion {
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    
    [postQuery includeKey:@"dish"];
    [postQuery whereKey:@"author" equalTo:currentUser];
    
    PFQuery *dishQuery = [PFQuery queryWithClassName:@"Dish"];
    [dishQuery whereKey:@"restaurantID" containedIn:restaurantIds];
    [dishQuery includeKeys:@[@"avgRating", @"numCheckIns"]];
    
    [postQuery whereKey:@"dish" matchesQuery:dishQuery];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        completion(posts,error);
    }];
}

+ (Dish *) getTopDishWithDishes:(NSMutableArray *) dishes
             withSortImportance:(BOOL) taste {
    
    if (dishes.count == 0) {
        return nil;
    }
    
    NSSortDescriptor *numCheckInsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numCheckIns"
                                                                              ascending:NO];
    NSSortDescriptor *ratingSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"avgRating"
                                                                         ascending:NO];
    
    NSMutableArray *sorts = [[NSMutableArray alloc] init];
    [sorts addObject:numCheckInsSortDescriptor];
    
    if (taste) {
        [sorts insertObject:ratingSortDescriptor atIndex:0];
    } else {
        [sorts addObject:ratingSortDescriptor];
    }
    
    [dishes sortUsingDescriptors:sorts];
    return dishes[0];
}


@end
