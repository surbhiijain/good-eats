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

@interface RestaurantMKAnnotationView : NSObject <MKAnnotation>

@property (nonatomic, readwrite)
CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, strong) Restaurant *restaurant;

-(id)initWithRestaurant: (Restaurant *) restaurant;
- (MKAnnotationView *) annotationView;

@end

NS_ASSUME_NONNULL_END
