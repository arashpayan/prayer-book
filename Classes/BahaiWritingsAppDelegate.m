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
	
	// Create the About view
	AboutViewController *aboutViewController = [[AboutViewController alloc] init];
	[allViewControllers addObject:aboutViewController];
	[aboutViewController release];
	
	// Create a tab bar controller to hold all the view controllers
	tabBarController = [[AppleIsStupid alloc] init];
	[tabBarController setViewControllers:allViewControllers];
	
	// Try to load up the saved state
	@try {
		NSArray *savedPrefs = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)@"savedState", kCFPreferencesCurrentApplication);
		if (savedPrefs != nil)
		{
			NSMutableArray *savedState = [[NSMutableArray alloc] init];
			[savedState addObjectsFromArray:savedPrefs];
			NSNumber *indexNumber = (NSNumber*)[savedState objectAtIndex:0];
			[savedState removeObjectAtIndex:0];
			int index = [indexNumber intValue];
			[tabBarController setSelectedIndex:index];
			
			if ([savedState count] > 0)
			{
				if (index == 0)
					[prayerCategoryViewController loadSavedState:savedState];
				else if (index == 1)
					[bookmarksViewController loadSavedState:savedState];
				else if (index == 2)
					[recentViewController loadSavedState:savedState];
				else if (index == 3)
					[searchViewController loadSavedState:savedState];
			}
			
			[savedState release];
			
			CFRelease(savedPrefs);
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Trouble loading up the app's saved state. Maybe you changed languages?");
		CFPreferencesSetAppValue((CFStringRef)@"savedState", nil, kCFPreferencesCurrentApplication);
	}
	
	// remove the launch image view and add the real app view
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	[Appirater appLaunched:YES];
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSMutableArray *saveState = [[NSMutableArray alloc] init];

	int index = [tabBarController selectedIndex];
	[saveState addObject:[NSNumber numberWithInt:index]];
	if (index == 0)
	{
		UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
		UIViewController *vc = navController.topViewController;
		if ([vc isKindOfClass:[PrayerListViewController class]])
		{
			[saveState addObject:[(PrayerListViewController*)vc category]];
		}
		else if ([vc isKindOfClass:[PrayerViewController class]])
		{
			Prayer *prayer = [(PrayerViewController*)vc prayer];
			[saveState addObject:prayer.category];
			
			[saveState addObject:[NSNumber numberWithLong:prayer.prayerId]];
		}
	}
	else if (index == 1 || index == 2)
	{
		UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
		UIViewController *vc = navController.topViewController;
		if ([vc isKindOfClass:[PrayerViewController class]])
		{
			Prayer *prayer = [(PrayerViewController*)vc prayer];
			[saveState addObject:[NSNumber numberWithLong:prayer.prayerId]];
		}
	}
	else if (index == 3)
	{
		UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
		SearchViewController *vc = (SearchViewController*)navController.topViewController;
		if (vc.currQuery != nil)
			[saveState addObject:vc.currQuery];
		else
			[saveState addObject:@""];
	}
	// we don't need to do anything else if index == 4 (the about page)

	CFPreferencesSetAppValue((CFStringRef)@"savedState", saveState, kCFPreferencesCurrentApplication);
	
	[saveState release];
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
