//
//  RestaurantMKAnnotationView.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/28/21.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantMKAnnotationView : MKPointAnnotation

@property (nonatomic, strong) Restaurant *restaurant;

-(id)initWithRestaurant: (Restaurant *) restaurant;

@end

NS_ASSUME_NONNULL_END
