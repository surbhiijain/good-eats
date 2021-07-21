//
//  RestaurantPostCollectionCell.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantPostCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@property (nonatomic, strong) Post *post;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
