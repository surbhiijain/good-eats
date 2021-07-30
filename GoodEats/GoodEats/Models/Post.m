//
//  Post.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/13/21.
//

#import "Post.h"
@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic rating;
@dynamic tags;
@dynamic dish;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage:(UIImage *)image
           withCaption:(NSString *)caption
              withDish:(Dish *)dish
            withRating:(NSNumber *)rating
              withTags:(NSArray *)tags
        withCompletion:(PFBooleanResultBlock)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.dish = dish;
    newPost.rating = rating;
    newPost.tags = tags;
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage:(UIImage *)image {
    
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
