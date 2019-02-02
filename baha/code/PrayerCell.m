//
//  PrayerTableCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerCell.h"
#import "PBUI.h"

@implementation PrayerCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		UIColor *whiteColor = [UIColor whiteColor];
		
		self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:16];
		self.title.highlightedTextColor = whiteColor;
		
		self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(PBUI.cellMargin, 28, 200, 14)];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat width = self.contentView.bounds.size.width;
    
    [self.rightLabel sizeToFit];
    self.rightLabel.center = CGPointMake(width - self.rightLabel.bounds.size.width/2.0,
                                         CGRectGetMaxY(self.contentView.bounds)/2.0);
    
    CGFloat leftWidth = CGRectGetMinX(self.rightLabel.frame) - 12 - PBUI.cellMargin;
    
    // calculate the total amount of height we need
    [self.title sizeToFit];
    [self.subtitle sizeToFit];
    CGFloat neededHeight = self.title.bounds.size.height + 4 + self.subtitle.bounds.size.height;
    
    self.title.frame = CGRectMake(PBUI.cellMargin,
                                  (height-neededHeight)/2.0,
                                  leftWidth,
                                  self.title.bounds.size.height);
    
    self.subtitle.frame = CGRectMake(PBUI.cellMargin,
                                     CGRectGetMaxY(self.title.frame) + 4,
                                     leftWidth,
                                     self.subtitle.bounds.size.height);
}

@end
