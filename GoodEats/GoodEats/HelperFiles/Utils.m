//
//  Utils.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils

+ (void)setStarFills:(NSNumber *)rating
           withStars:(NSMutableArray *)stars {
    float roundedRating = [rating floatValue] < 0.5f ? 0.5f : floorf([rating floatValue] * 2) / 2;
    
    UIImage *fill =  [UIImage systemImageNamed:@"star.fill"];
    UIImage *half = [UIImage systemImageNamed:@"star.leadinghalf.fill"];
    
    while (roundedRating > 0.0f) {
        UIImageView *star = stars[0];
        [stars removeObject:star];
        if (roundedRating == 0.5f) {
            [star setImage:half];
            roundedRating = 0.0f;
        } else {
            [star setImage:fill];
            roundedRating = roundedRating - 1.0f;
        }
        [star setTintColor:[UIColor systemYellowColor]];
    }
}

@end
