//
//  AppDelegate.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/20.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TXLiveBase.h"  //TRTC
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
     [TXLiveBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/5f901ebb7ffb139ab68f6d7343011500/TXLiveSDK.licence" key:@"9a344e2f2cf615b2d44fc65342a19c73"];
    
      [NSThread sleepForTimeInterval:3.0]; //引导页休眠时间
     MainViewController *main=[[MainViewController  alloc]init];
    // UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:main];
   
    self.window.rootViewController=main;
    // Override point for customization after application launch.
    return YES;
}


//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
