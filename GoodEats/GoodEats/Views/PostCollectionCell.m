//
//  PostCollectionCell.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

- (void)setPost:(Post *)post {
    _post = post;
    [self.post.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *image = [UIImage imageWithData:imageData];
        [self.postImage setImage:image] ;
    }];
}

@end
