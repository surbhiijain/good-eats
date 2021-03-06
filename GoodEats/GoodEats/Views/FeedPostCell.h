//
//  TableViewCell.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@class FeedPostCell;

@protocol FeedPostCellDelegate

- (void) callRestaurantSegueFromCell: (FeedPostCell *) cell;

@end

@interface FeedPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;

@property (weak, nonatomic) IBOutlet UIButton *dishButton;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reviewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *reviewStar5;

@property (weak, nonatomic) IBOutlet UIButton *tagButton1;
@property (weak, nonatomic) IBOutlet UIButton *tagButton2;
@property (weak, nonatomic) IBOutlet UIButton *tagButton3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton4;
@property (weak, nonatomic) IBOutlet UIButton *tagButton5;

@property (nonatomic, strong) Post *post;

@property (nonatomic, strong) Restaurant *restaurant;

@property (weak, nonatomic) id<FeedPostCellDelegate> delegate;

- (void) setDishButtonTitle;

@end

NS_ASSUME_NONNULL_END
