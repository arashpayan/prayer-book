//
//  BahaiWritingsAppDelegate.h
//  BahaiWritings
//
//  Created by Arash Payan on 7/20/08.
//  Copyright Arash Payan 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class APWindow;

@interface BahaiWritingsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
	IBOutlet APWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) APWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

