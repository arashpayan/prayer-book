//
//  PrayerViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Prayer.h"
#import "PrayerDatabase.h"
#import "QiblihWatcherDelegate.h"

@interface PrayerViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, QiblihWatcherDelegate> {
	Prayer *_prayer;
	PrayerDatabase *prayerDatabase;
	NSString *backButtonTitle;
	//NSString *prayerHTML;
	
	BOOL composingMail;
}

+ (NSString*)HTMLPrefix;
+ (NSString*)HTMLSuffix;

- (id)initWithPrayer:(Prayer*)prayer backButtonTitle:(NSString*)aBackButtonTitle;
- (Prayer*)prayer;
- (BOOL)bookmarkingEnabled;
- (NSString*)finalPrayerHTML;
- (BOOL)increaseTextSizeActionEnabled;
- (BOOL)decreaseTextSizeActionEnabled;

@end
