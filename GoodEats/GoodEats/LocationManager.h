//
//  LocationManager.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/22/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (void) setUpLocationManager;

@end

NS_ASSUME_NONNULL_END
