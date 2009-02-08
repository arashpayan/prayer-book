//
//  PrayerViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Prayer.h"
#import "PrayerDatabase.h"

@interface PrayerViewController : UIViewController <UIActionSheetDelegate> {
	UIWebView *webView;
	Prayer *_prayer;
	PrayerDatabase *prayerDatabase;
}

+ (NSString*)HTMLPrefix;
+ (NSString*)HTMLSuffix;

- (id)initWithPrayer:(Prayer*)prayer;
- (Prayer*)prayer;

@end
