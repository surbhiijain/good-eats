//
//  LocationManager.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/22/21.
//

#import "LocationManager.h"

@interface LocationManager ()


@end

@implementation LocationManager

- (void) setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
        
        [self.delegate LocationManager:self setUpWithLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Location update failed %@", error);
}

@end
