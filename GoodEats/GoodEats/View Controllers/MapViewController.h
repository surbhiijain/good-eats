//
//  MapViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "LocationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <ComposeViewControllerDelegate, UITabBarControllerDelegate, LocationManagerDelegate>

@end

NS_ASSUME_NONNULL_END
