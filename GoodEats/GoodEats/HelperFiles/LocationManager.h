//
//  LocationManager.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/22/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@class LocationManager;

@protocol LocationManagerDelegate

- (void)LocationManager:(LocationManager *)locationManager
      setUpWithLocation:(CLLocation *)location;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id<LocationManagerDelegate> delegate;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void) setUpLocationManager;

@end

NS_ASSUME_NONNULL_END
