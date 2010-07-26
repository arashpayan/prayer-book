//
//  PrayerTableCell.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrayerTableCell : UITableViewCell {
	UILabel *title;
	UILabel *subtitle;
	UILabel *rightLabel;
}

@property (nonatomic, readonly) UILabel *title;
@property (nonatomic, readonly) UILabel *subtitle;
@property (nonatomic, readonly) UILabel *rightLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
