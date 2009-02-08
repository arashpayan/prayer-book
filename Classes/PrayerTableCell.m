//
//  PrayerTableCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerTableCell.h"


@implementation PrayerTableCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		UIColor *blackColor = [UIColor blackColor];
		UIColor *whiteColor = [UIColor whiteColor];
		
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
		
		rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 28, 50, 14)];
		rightLabel.textColor = [UIColor blueColor];
		rightLabel.highlightedTextColor = whiteColor;
		rightLabel.font = [UIFont italicSystemFontOfSize:10];
		rightLabel.textAlignment = UITextAlignmentRight;
		
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:categoryLabel];
		[self.contentView addSubview:rightLabel];
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
	
	CGRect rightRect = CGRectMake(CGRectGetMaxX(frame)-90, 28, 65, 14);
	rightLabel.frame = rightRect;
	
	[super setFrame:frame];
}

- (UILabel*)titleLabel {
	return titleLabel;
}

- (UILabel*)categoryLabel {
	return categoryLabel;
}

- (UILabel*)rightLabel {
	return rightLabel;
}


- (void)dealloc {
	[titleLabel release];
	[categoryLabel release];
	[rightLabel release];
	[super dealloc];
}


@end
