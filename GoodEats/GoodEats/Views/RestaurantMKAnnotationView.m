//
//  RestaurantMKAnnotationView.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/28/21.
//

#import "RestaurantMKAnnotationView.h"

@implementation RestaurantMKAnnotationView

- (id)initWithRestaurant:(Restaurant *)restaurant {
    self = [super init];
    if (self) {
        self.restaurant = restaurant;
        self.title = restaurant.name;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(restaurant.latitude.floatValue, restaurant.longitude.floatValue);
        self.coordinate = location;
    }
    return self;
}


- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"RestaurantMKAnnotation"];
    

    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    annotationView.image = [UIImage systemImageNamed:@"mappin"];
    [annotationView setTintColor:[UIColor redColor]];
    
    return annotationView;
}

@end
