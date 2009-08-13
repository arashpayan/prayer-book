//
//  APWindow.h
//  BahaiWritings
//
//  Created by Arash Payan on 7/30/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PrayerDatabase.h"

@interface APWindow : UIWindow {
	PrayerDatabase *database;
	
	CGPoint startPos;
}

@end
