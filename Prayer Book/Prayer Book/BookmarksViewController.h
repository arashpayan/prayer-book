//
//  BookmarksViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrayerDatabase.h"
#import "PrayerTableCell.h"


@interface BookmarksViewController : UITableViewController

- (void)loadSavedState:(NSMutableArray*)savedState;

@end
