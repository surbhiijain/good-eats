//
//  ComposeViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@class ComposeViewController;

@protocol ComposeViewControllerDelegate

- (void)ComposeViewController:(ComposeViewController *)controller postedRestaurant:(Restaurant *)restaurat;

@end

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
