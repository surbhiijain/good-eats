//
//  RestaurantPopularDishesViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantPopularDishesViewController : UIViewController

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSString *restaurantId;


@end

NS_ASSUME_NONNULL_END
