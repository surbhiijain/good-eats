//
//  DishDetailsViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DishDetailsViewControllerDelegate

- (void)dishDetailVCSavedDish;

@end

@interface DishDetailsViewController : UIViewController

@property (nonatomic, strong) Dish *dish;
@property (nonatomic, weak) id<DishDetailsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
