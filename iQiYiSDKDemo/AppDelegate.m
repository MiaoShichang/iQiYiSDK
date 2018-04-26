//
//  AppDelegate.m
//  iQiYiSDKDemo
//
//  Created by miaoshichang on 2018/4/25.
//  Copyright © 2018年 MiaoShichang. All rights reserved.
//

#import "AppDelegate.h"

#import "IQYSDK.h"

//从这里设置从开放平台申请到的appKey
 #define kQIYIAppKey @"8aaaeae9766a4c8da4fefdd193e8cd0b"
#ifndef kQIYIAppKey
#error
#endif

//在这里设置从开放平台申请到的appSercet
#define kQIYIAppSecret @"a18b53afec981b2abe7e5afda65ba388"
#ifndef kQIYIAppSecret
#error
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[IQYSDK shareInstance]setAppKey:kQIYIAppKey appSecret:kQIYIAppSecret];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
