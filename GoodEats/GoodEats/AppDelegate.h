//
//  AppDelegate.h
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import <UIKit/UIKit.h>

@class YLPClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (YLPClient *)sharedClient;

@end

