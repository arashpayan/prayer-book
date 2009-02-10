//
//  BahaiWritingsAppDelegate.m
//  BahaiWritings
//
//  Created by Arash Payan on 7/20/08.
//  Copyright Arash Payan 2008. All rights reserved.
//

#import "BahaiWritingsAppDelegate.h"

@implementation BahaiWritingsAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	NSMutableArray *allViewControllers = [NSMutableArray arrayWithCapacity:5];
	
	// Create the prayer category view
	PrayerCategoryViewController *prayerCategoryViewController = [[PrayerCategoryViewController alloc] init];
	UINavigationController *prayerNavController = [[UINavigationController alloc] initWithRootViewController:prayerCategoryViewController];
	UIImage *prayersTabImg = [UIImage imageNamed:@"Prayers2.png"];
	[prayerNavController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PRAYERS", nil) image:prayersTabImg tag:0]];
	[prayerCategoryViewController release];	// the nav controller will retain it
	[allViewControllers addObject:prayerNavController];
	[prayerNavController release];
	
	// Create the Bookmarks view
	BookmarksViewController *bookmarksViewController = [[BookmarksViewController alloc] init];
	UINavigationController *bookmarksNavController = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController];
	[bookmarksViewController release];
	[allViewControllers addObject:bookmarksNavController];
	[bookmarksNavController release];
	
	// Create the Recents view
	RecentViewController *recentViewController = [[RecentViewController alloc] init];
	UINavigationController *recentNavController = [[UINavigationController alloc] initWithRootViewController:recentViewController];
	[allViewControllers addObject:recentNavController];
	[recentNavController release];
	
	// Add the search view
	SearchViewController *searchViewController = [[SearchViewController alloc] init];
	UINavigationController *searchNavController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	[allViewControllers addObject:searchNavController];
	
	// Create the About view
	AboutViewController *aboutViewController = [[AboutViewController alloc] initWithWindow:window];
	[allViewControllers addObject:aboutViewController];
	[aboutViewController release];
	
	// Create a tab bar controller to hold all the view controllers
	tabBarController = [[AppleIsStupid alloc] init];
	[tabBarController setViewControllers:allViewControllers];
	
	// Load up the saved state
	//NSArray *savedPrefs = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)@"savedState", kCFPreferencesCurrentApplication);
//	if (savedPrefs != nil)
//	{
//		NSMutableArray *savedState = [[NSMutableArray alloc] init];
//		[savedState addObjectsFromArray:savedPrefs];
//		NSNumber *indexNumber = (NSNumber*)[savedState objectAtIndex:0];
//		[savedState removeObjectAtIndex:0];
//		int index = [indexNumber intValue];
//		[tabBarController setSelectedIndex:index];
//		
//		if ([savedState count] > 0)
//		{
//			if (index == 0)
//				[prayerCategoryViewController loadSavedState:savedState];
//			else if (index == 1)
//				[bookmarksViewController loadSavedState:savedState];
//			else if (index == 2)
//				[recentViewController loadSavedState:savedState];
//		}
//		
//		[savedState release];
//		
//		CFRelease(savedPrefs);
//	}
	
	// remove the launch image view and add the real app view
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	//NSMutableArray *saveState = [[NSMutableArray alloc] init];
//	
//	int index = [tabBarController selectedIndex];
//	[saveState addObject:[NSNumber numberWithInt:index]];
//	if (index == 0)
//	{
//		UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
//		UIViewController *vc = navController.topViewController;
//		if ([vc isKindOfClass:[PrayerListViewController class]])
//		{
//			[saveState addObject:[(PrayerListViewController*)vc category]];
//		}
//		else if ([vc isKindOfClass:[PrayerViewController class]])
//		{
//			Prayer *prayer = [(PrayerViewController*)vc prayer];
//			[saveState addObject:[prayer category]];
//			
//			NSMutableDictionary *prayerBookmark = [[NSMutableDictionary alloc] initWithCapacity:2];
//			[prayerBookmark setObject:[prayer title] forKey:kBookmarkKeyTitle];
//			[prayerBookmark setObject:[prayer category] forKey:kBookmarkKeyCategory];
//			[saveState addObject:prayerBookmark];
//		}
//	}
//	else if (index == 1 || index == 2)
//	{
//		UINavigationController *navController = (UINavigationController*)[tabBarController selectedViewController];
//		UIViewController *vc = navController.topViewController;
//		if ([vc isKindOfClass:[PrayerViewController class]])
//		{
//			Prayer *prayer = [(PrayerViewController*)vc prayer];
//			NSMutableDictionary *prayerBookmark = [[NSMutableDictionary alloc] initWithCapacity:2];
//			[prayerBookmark setObject:[prayer title] forKey:kBookmarkKeyTitle];
//			[prayerBookmark setObject:[prayer category] forKey:kBookmarkKeyCategory];
//			[saveState addObject:prayerBookmark];
//		}
//	}
//	// we don't need to do anything if index == 3 (the about page)
//	
//	CFPreferencesSetAppValue((CFStringRef)@"savedState", saveState, kCFPreferencesCurrentApplication);
}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
