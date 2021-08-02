//
//  RestaurantSearchCell.h
//  GoodEats
//
//  Created by Surbhi Jain on 8/2/21.
//

#import <UIKit/UIKit.h>
#import <YelpAPI/YLPBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) YLPBusiness *YLPRestaurant;

@end

NS_ASSUME_NONNULL_END
