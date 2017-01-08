//
//  AppDelegate.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ListViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <EBForeNotification.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [application setApplicationIconBadgeNumber:0];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    //接收通知
    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo= notification.userInfo;
    if (userInfo) {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    }
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController  * home = [[HomeViewController alloc]init];
    _window.rootViewController = home;
    [_window makeKeyWindow];
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
     //系统声音弹窗
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark 进入前台后设置消息信息
-(void)applicationWillEnterForeground:(UIApplication *)application{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
