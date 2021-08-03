//
//  RestaurantSearchViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 8/2/21.
//

#import <UIKit/UIKit.h>
#import <YelpAPI/YLPBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@class RestaurantSearchViewController;

@protocol RestaurantSearchViewControllerDelegate

- (void)RestaurantSearchViewController:(RestaurantSearchViewController *) controller selectedRestaurant:(YLPBusiness *) yelpRestaurant;

@end

@interface RestaurantSearchViewController : UIViewController

@property (weak, nonatomic) id<RestaurantSearchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
