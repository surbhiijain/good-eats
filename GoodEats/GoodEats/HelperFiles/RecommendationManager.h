//
//  RecommendationManager.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#ifndef RecommendationManager_h
#define RecommendationManager_h

#import <MapKit/MapKit.h>
#import "Dish.h"

@interface RecommendationManager : NSObject

+ (void) getRecommendedDishWithDist:(double) dist
                          withTaste:(BOOL) taste
                 withAdventureIndex:(int) adventureIndex
                    withUserLoation: (CLLocation *) userLocation
                     withCompletion:(void(^)(Dish *dish, NSString *noRecsErrorString))completion;

@end

#endif /* RecommendationManager_h */
