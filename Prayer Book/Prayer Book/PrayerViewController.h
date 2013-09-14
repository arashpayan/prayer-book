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
@class PrayerView;

@interface PrayerViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

+ (NSString*)HTMLPrefix:(NSString*)language;
+ (NSString*)HTMLSuffix;

- (id)initWithPrayer:(Prayer*)prayer backButtonTitle:(NSString*)aBackButtonTitle;
- (BOOL)bookmarkingEnabled;
- (NSString*)finalPrayerHTML;
- (BOOL)increaseTextSizeActionEnabled;
- (BOOL)decreaseTextSizeActionEnabled;

@end
