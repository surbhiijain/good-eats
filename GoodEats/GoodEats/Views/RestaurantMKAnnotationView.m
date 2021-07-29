//
//  RestaurantMKAnnotationView.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/28/21.
//

#import "RestaurantMKAnnotationView.h"

@implementation RestaurantMKAnnotationView

- (id)initWithRestaurant:(Restaurant *)restaurant {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(restaurant.latitude.floatValue, restaurant.longitude.floatValue);

    self = [super initWithCoordinate:location title:restaurant.name subtitle:nil];
    if (self) {
        self.restaurant = restaurant;
    }
    return self;
}

@end
