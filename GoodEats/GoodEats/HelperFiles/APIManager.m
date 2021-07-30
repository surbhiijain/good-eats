//
//  APIManager.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/30/21.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "Parse/Parse.h"
#import "Restaurant.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
