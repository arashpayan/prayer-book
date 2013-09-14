//
//  CategoryCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "CategoryCell.h"


@implementation CategoryCell

//@synthesize categoryLabel;
//@synthesize countLabel;
//@synthesize roundedRectangle;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
//	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 240, 30)];
		self.categoryLabel.font = [UIFont boldSystemFontOfSize:20];
		self.categoryLabel.highlightedTextColor = [UIColor whiteColor];
		
		CGRect countRect = CGRectMake(260, 12, 32, 20);
		self.countLabel = [[UILabel alloc] initWithFrame:countRect];
		self.countLabel.font = [UIFont boldSystemFontOfSize:14];
		self.countLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
		self.countLabel.opaque = YES;
		self.countLabel.textColor = [UIColor whiteColor];
		self.countLabel.textAlignment = NSTextAlignmentCenter;
		self.countLabel.highlightedTextColor = [UIColor colorWithRed:2.0/255.0 green:114.0/255.0 blue:237.0/255.0 alpha:1];
		self.roundedRectangle = [[RoundedRectangleView alloc] initWithFrame:countRect];
		
		//[self.contentView addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayerBackground.jpg"]] autorelease]];
		
		[self.contentView addSubview:self.categoryLabel];
		[self.contentView addSubview:self.roundedRectangle];
		[self.contentView addSubview:self.countLabel];
	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	CGRect countRect = CGRectMake(CGRectGetMaxX(frame)-70, 12, 32, 20);
	self.countLabel.frame = countRect;
	self.roundedRectangle.frame = countRect;
	
	CGRect categoryRect = CGRectMake(10, 6, CGRectGetMaxX(frame)-90, 30);
	self.categoryLabel.frame = categoryRect;
	
	[super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
	self.categoryLabel.highlighted = selected;
	self.countLabel.highlighted = selected;
	[self.roundedRectangle setHighlighted:selected];
}
		
- (void)setCategory:(NSString*)aCategory {
	self.categoryLabel.text = aCategory;
}

- (void)setCount:(NSString*)aCount {
	self.countLabel.text = aCount;
}


@end
