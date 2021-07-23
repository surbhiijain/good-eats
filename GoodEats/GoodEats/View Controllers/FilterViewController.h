//
//  FilterViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/22/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FilterViewController;

@protocol  FilterViewDelegate

- (void) FilterViewController:(FilterViewController *) filterViewController reloadFeedWithRestaurants: (NSMutableArray *) restaurants;

@end

@interface FilterViewController : UIViewController

@property (weak, nonatomic) id<FilterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
