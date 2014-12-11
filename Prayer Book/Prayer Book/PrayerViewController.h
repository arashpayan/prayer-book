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

@interface PrayerViewController : UIViewController

- (id)initWithPrayer:(Prayer*)prayer;

@end
