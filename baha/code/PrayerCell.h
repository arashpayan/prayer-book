//
//  PrayerTableCell.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrayerCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UILabel *rightLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
