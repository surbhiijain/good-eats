//
//  TableFeedViewController.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableFeedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *handleArea;

@property (nonatomic, strong) NSMutableArray *validRestaurantIds;

- (void) fetchPosts;

@end

NS_ASSUME_NONNULL_END
