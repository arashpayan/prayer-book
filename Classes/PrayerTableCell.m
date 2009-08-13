//
//  PrayerTableCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerTableCell.h"


@implementation PrayerTableCell

@synthesize title;
@synthesize subtitle;
@synthesize rightLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		UIColor *blackColor = [UIColor blackColor];
		UIColor *whiteColor = [UIColor whiteColor];
		
		title = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 280, 20)];
		title.backgroundColor = whiteColor;
		title.textColor = blackColor;
		title.highlightedTextColor = whiteColor;
		title.opaque = YES;
		title.font = [UIFont boldSystemFontOfSize:16];
		
		subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 200, 14)];
		subtitle.backgroundColor = whiteColor;
		subtitle.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1];
		subtitle.highlightedTextColor = whiteColor;
		subtitle.opaque = YES;
		subtitle.font = [UIFont italicSystemFontOfSize:13];
		
		rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 28, 50, 14)];
		rightLabel.textColor = [UIColor blueColor];
		rightLabel.highlightedTextColor = whiteColor;
		rightLabel.font = [UIFont italicSystemFontOfSize:13];
		rightLabel.textAlignment = UITextAlignmentRight;
		
		[self.contentView addSubview:title];
		[self.contentView addSubview:subtitle];
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
	title.frame = titleRect;
	
	CGRect rightRect = CGRectMake(CGRectGetMaxX(frame)-125, 28, 100, 14);
	rightLabel.frame = rightRect;
	
	[super setFrame:frame];
}

- (void)dealloc {
	[title release];
	[subtitle release];
	[rightLabel release];
	[super dealloc];
}


@end
