//
//  PrayerResultsController.h
//  baha
//
//  Created by Arash on 2/2/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrayerResultsController : UIViewController

@property (nonatomic, readwrite) UITableView *table;
- (instancetype)init;
@property (nonatomic, retain) NSArray<Prayer*> *results;

@end

NS_ASSUME_NONNULL_END
