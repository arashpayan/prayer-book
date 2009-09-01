//
//  PrayerCategoryViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrayerDatabase.h"
#import "PrayerListViewController.h"
#import "CategoryCell.h"

@interface PrayerCategoryViewController : UITableViewController {
	NSDictionary *categories;
	PrayerDatabase *prayerDb;
	UILabel *countLabel;
	
	NSArray *languages;
}

- (void)loadSavedState:(NSMutableArray*)savedState;

@end
