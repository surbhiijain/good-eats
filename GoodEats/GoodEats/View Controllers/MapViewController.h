//
//  MapViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "LocationManager.h"
#import "FilterViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <ComposeViewControllerDelegate, UITabBarControllerDelegate, LocationManagerDelegate, FilterViewDelegate>

@end

NS_ASSUME_NONNULL_END
