//
//  PrayerTableCell.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrayerTableCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *categoryLabel;
	UILabel *rightLabel;
}

- (UILabel*)titleLabel;
- (UILabel*)categoryLabel;
- (UILabel*)rightLabel;

@end
