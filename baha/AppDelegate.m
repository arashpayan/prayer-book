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
#import "LanguagesController.h"
#import "AboutController.h"
#import "PBUI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PBUI installTheme];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    CategoriesController *pcvc = [CategoriesController new];
    UINavigationController *pcvcNavController = [[UINavigationController alloc] initWithRootViewController:pcvc];

    BookmarksViewController *bookmarksController = [BookmarksViewController new];
    UINavigationController *bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksController];

    RecentViewController *recentController = [RecentViewController new];
    UINavigationController *recentNavController = [[UINavigationController alloc] initWithRootViewController:recentController];

    LanguagesController *settingsController = [LanguagesController new];
    UINavigationController *languagesNC = [[UINavigationController alloc] initWithRootViewController:settingsController];

    AboutController *about = [AboutController new];
    UINavigationController *aboutNC = [[UINavigationController alloc] initWithRootViewController:about];

    UITabBarController *tabBarController = [UITabBarController new];
    [tabBarController setViewControllers:@[pcvcNavController, bookmarksNavController, recentNavController, languagesNC, aboutNC]];

    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];


    return YES;
}

@end
