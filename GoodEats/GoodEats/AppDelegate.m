//
//  AppDelegate.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>


@import YelpAPI;

@interface AppDelegate ()

@property (strong, nonatomic) YLPClient *client;

@end

@implementation AppDelegate

+ (YLPClient *)sharedClient {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.client;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(  NSDictionary *)launchOptions {

    // initialize Parse
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = @"VxKv8fRHHCG5j2pNHKo2ADudXvikPgzk3tWvA8kk";
        configuration.clientKey = @"XTdpNfUzlrmmYTj0u0ZALMG3umvKXIBNdVQTguNI";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    
    // initialize Yelp API
    self.client = [[YLPClient alloc] initWithAPIKey:@"eTulyoeceO4Xzju1opElKyvTSDQtrdTa7OcEHbgTPvAJDFco9DMxUPgcLr9Q9UhQum4hfjMcxLkXQA0fvHUDLyyO1JoQMkoND1Vl3TEPxozlJvsNVBOr_3alzur1YHYx"];
    
    [Chameleon setGlobalThemeUsingPrimaryColor:FlatTeal  withContentStyle:UIContentStyleLight];


    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
