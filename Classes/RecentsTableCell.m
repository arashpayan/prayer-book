//
//  PrayerTableCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "RecentsTableCell.h"


@implementation RecentsTableCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		blackColor = [UIColor blackColor];
		whiteColor = [UIColor whiteColor];
		blueishColor = [UIColor colorWithRed:2.0/255.0 green:114.0/255.0 blue:237.0/255.0 alpha:1];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 280, 20)];
		titleLabel.backgroundColor = whiteColor;
		titleLabel.textColor = blackColor;
		titleLabel.highlightedTextColor = whiteColor;
		titleLabel.opaque = YES;
		titleLabel.font = [UIFont boldSystemFontOfSize:16];
		
		categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 200, 14)];
		categoryLabel.backgroundColor = whiteColor;
		categoryLabel.textColor = blackColor;
		categoryLabel.highlightedTextColor = whiteColor;
		categoryLabel.opaque = YES;
		categoryLabel.font = [UIFont italicSystemFontOfSize:10];
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:categoryLabel];
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
	CGRect titleRect = CGRectMake(10, 4, CGRectGetMaxX(frame)-40, 20);
	titleLabel.frame = titleRect;
	
	[super setFrame:frame];
}

- (UILabel*)titleLabel {
	return titleLabel;
}

- (UILabel*)categoryLabel {
	return categoryLabel;
}


- (void)dealloc {
	[titleLabel dealloc];
	[categoryLabel dealloc];
	[super dealloc];
}


@end
