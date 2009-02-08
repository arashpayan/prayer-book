//
//  PrayerListViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrayerViewController.h"
#import "PrayerTableCell.h"

@interface PrayerListViewController : UITableViewController {
	NSArray *prayers;
	NSString *category;
}

@property (nonatomic, retain) NSArray *prayers;

- (void)setCategory:(NSString*)aCategory;
- (NSString*)category;

@end
