//
//  AppDelegate.m
//  baha
//
//  Created by Arash Payan on 9/11/15.
//  Copyright (c) 2015 Arash Payan. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoriesController.h"
#import "BookmarksViewController.h"
#import "RecentViewController.h"
#import "SettingsController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    CategoriesController *pcvc = [CategoriesController new];
    UINavigationController *pcvcNavController = [[UINavigationController alloc] initWithRootViewController:pcvc];

    BookmarksViewController *bookmarksController = [BookmarksViewController new];
    UINavigationController *bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksController];

    RecentViewController *recentController = [RecentViewController new];
    UINavigationController *recentNavController = [[UINavigationController alloc] initWithRootViewController:recentController];

    SettingsController *settingsController = [SettingsController new];

    UITabBarController *tabBarController = [UITabBarController new];
    [tabBarController setViewControllers:@[pcvcNavController, bookmarksNavController, recentNavController, settingsController]];

    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];


    return YES;
}

@end
