//
//  Post.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) Dish *dish;


+ (void) postUserImage:(UIImage *)image
           withCaption:(NSString *)caption
              withDish:(Dish *)dish
            withRating:(NSNumber *)rating
              withTags:(NSArray *)tags
        withCompletion:(PFBooleanResultBlock)completion;

@end

NS_ASSUME_NONNULL_END


