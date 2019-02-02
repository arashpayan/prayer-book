//
//  CategoryPrayersController.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrayerViewController.h"
#import "PrayerCell.h"

@interface CategoryPrayersController : UITableViewController

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *prayers;

@end
