//
//  PBAppDelegate.m
//  Prayer Book
//
//  Created by Arash Payan on 9/11/13.
//  Copyright (c) 2013 Arash Payan. All rights reserved.
//

#import "PBAppDelegate.h"
#import "PrayerCategoryViewController.h"
#import "BookmarksViewController.h"
#import "RecentViewController.h"
#import "SearchViewController.h"
#import "SettingsController.h"
#import "Appirater.h"
#import "PBUI.h"

@implementation PBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    PrayerCategoryViewController *pcvc = [[PrayerCategoryViewController alloc] init];
    UINavigationController *pcvcNavController = [[UINavigationController alloc] initWithRootViewController:pcvc];
    
    BookmarksViewController *bookmarksController = [[BookmarksViewController alloc] init];
    UINavigationController *bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksController];
    
    RecentViewController *recentController = [[RecentViewController alloc] init];
    UINavigationController *recentNavController = [[UINavigationController alloc] initWithRootViewController:recentController];
    
    SearchViewController *searchController = [[SearchViewController alloc] init];
    UINavigationController *searchNavController = [[UINavigationController alloc] initWithRootViewController:searchController];
    
    SettingsController *settingsController = [[SettingsController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:
                                               pcvcNavController,
                                               bookmarksNavController,
                                               recentNavController,
                                               searchNavController,
                                               settingsController, nil]];
    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [Appirater setAppId:@"292151014"];
    [Appirater setOpenInAppStore:YES];
    [Appirater setDaysUntilPrompt:30];
    [Appirater setUsesUntilPrompt:20];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:7];

    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
