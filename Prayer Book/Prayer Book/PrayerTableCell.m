//
//  PrayerTableCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerTableCell.h"
#import "PBUI.h"

@implementation PrayerTableCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		UIColor *blackColor = [UIColor blackColor];
		UIColor *whiteColor = [UIColor whiteColor];
		
		self.title = [[UILabel alloc] initWithFrame:CGRectZero];
		self.title.backgroundColor = whiteColor;
		self.title.textColor = blackColor;
		self.title.highlightedTextColor = whiteColor;
		self.title.opaque = YES;
		self.title.font = [UIFont systemFontOfSize:16];
		
		self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(PBUI.cellMargin, 28, 200, 14)];
		self.subtitle.backgroundColor = whiteColor;
		self.subtitle.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1];
		self.subtitle.highlightedTextColor = whiteColor;
		self.subtitle.opaque = YES;
		self.subtitle.font = [UIFont systemFontOfSize:13];
		
		self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 28, 50, 14)];
		self.rightLabel.textColor = [UIColor colorWithRed:2.0/255.0 green:114.0/255.0 blue:237.0/255.0 alpha:1];
		self.rightLabel.highlightedTextColor = whiteColor;
		self.rightLabel.font = [UIFont systemFontOfSize:13];
		self.rightLabel.textAlignment = NSTextAlignmentRight;
		
		[self.contentView addSubview:self.title];
		[self.contentView addSubview:self.subtitle];
		[self.contentView addSubview:self.rightLabel];
	}
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
	CGRect titleRect = CGRectMake(PBUI.cellMargin, 4, CGRectGetMaxX(frame)-40, 20);
	self.title.frame = titleRect;
	
	CGRect rightRect = CGRectMake(CGRectGetMaxX(frame)-135, 28, 100, 14);
	self.rightLabel.frame = rightRect;
	
	[super setFrame:frame];
}

@end
