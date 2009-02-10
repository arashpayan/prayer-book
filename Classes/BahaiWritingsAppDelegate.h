//
//  BahaiWritingsAppDelegate.h
//  BahaiWritings
//
//  Created by Arash Payan on 7/20/08.
//  Copyright Arash Payan 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BookmarksViewController.h"
#import "RecentViewController.h"
#import "PrayerCategoryViewController.h"
#import "PrayerDatabase.h"
#import "AboutViewController.h"
#import "AppleIsStupid.h"
#import "SearchViewController.h";

@class BahaiWritingsViewController;

@interface BahaiWritingsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

