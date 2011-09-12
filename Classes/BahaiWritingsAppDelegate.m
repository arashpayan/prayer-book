//
//  BahaiWritingsAppDelegate.m
//  BahaiWritings
//
//  Created by Arash Payan on 7/20/08.
//  Copyright Arash Payan 2008. All rights reserved.
//

#import "BahaiWritingsAppDelegate.h"
#import "PrayerCategoryViewController.h"
#import "BookmarksViewController.h"
#import "RecentViewController.h"
#import "SearchViewController.h"
#import "AboutViewController.h"
#import "SettingsController.h"
#import "PrayerListViewController.h"
#import "Prayer.h"
#import "AppleIsStupid.h"
#import "QiblihFinder.h"
#import "Appirater.h"

@implementation BahaiWritingsAppDelegate

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	
	NSMutableArray *allViewControllers = [NSMutableArray arrayWithCapacity:5];
	
	// Create the prayer category view
	PrayerCategoryViewController *prayerCategoryViewController = [[PrayerCategoryViewController alloc] init];
	UINavigationController *prayerNavController = [[UINavigationController alloc] initWithRootViewController:prayerCategoryViewController];
	prayerNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	UIImage *prayersTabImg = [UIImage imageNamed:@"TabBarList.png"];
	[prayerNavController setTabBarItem:[[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PRAYERS", nil) image:prayersTabImg tag:0] autorelease]];
	[prayerCategoryViewController release];	// the nav controller will retain it
	[allViewControllers addObject:prayerNavController];
	[prayerNavController release];
	
	// Create the Bookmarks view
	BookmarksViewController *bookmarksViewController = [[BookmarksViewController alloc] init];
	UINavigationController *bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController];
	bookmarksNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[bookmarksViewController release];
	[allViewControllers addObject:bookmarksNavController];
	[bookmarksNavController release];
	
	// Create the Recents view
	RecentViewController *recentViewController = [[RecentViewController alloc] init];
	UINavigationController *recentNavController = [[UINavigationController alloc] initWithRootViewController:recentViewController];
	recentNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[allViewControllers addObject:recentNavController];
	[recentNavController release];
	
	// Add the search view
	SearchViewController *searchViewController = [[SearchViewController alloc] init];
	UINavigationController *searchNavController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	searchNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[allViewControllers addObject:searchNavController];
	[searchViewController release];
    
    // Create the settings view
    SettingsController *settingsController = [[[SettingsController alloc] init] autorelease];
    UINavigationController *settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsController];
    settingsNC.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [allViewControllers addObject:settingsNC];
	
	// Create a tab bar controller to hold all the view controllers
	tabBarController = [[AppleIsStupid alloc] init];
	[tabBarController setViewControllers:allViewControllers];
	
	// remove the launch image view and add the real app view
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	[Appirater appLaunched:YES];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[QiblihFinder sharedInstance].applicationActive = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[QiblihFinder sharedInstance].applicationActive = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[Appirater appEnteredForeground:YES];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
