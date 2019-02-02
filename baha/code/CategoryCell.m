//
//  CategoryCell.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "CategoryCell.h"
#import "PBUI.h"

@implementation CategoryCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.categoryLabel.font = [UIFont systemFontOfSize:20];
		self.categoryLabel.highlightedTextColor = UIColor.whiteColor;
		
		self.countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.countLabel.font = [UIFont systemFontOfSize:14];
		self.countLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
		self.countLabel.opaque = YES;
		self.countLabel.textColor = UIColor.whiteColor;
		self.countLabel.textAlignment = NSTextAlignmentCenter;
		self.countLabel.highlightedTextColor = [UIColor colorWithRed:2.0/255.0 green:114.0/255.0 blue:237.0/255.0 alpha:1];
		self.roundedRectangle = [[RoundedRectangleView alloc] initWithFrame:CGRectZero];
		
		[self.contentView addSubview:self.categoryLabel];
		[self.contentView addSubview:self.roundedRectangle];
		[self.contentView addSubview:self.countLabel];
	}
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect countRect = CGRectMake(CGRectGetMaxX(self.contentView.bounds)-44, 12, 32, 20);
    self.countLabel.frame = countRect;
    self.roundedRectangle.frame = countRect;
    
    CGFloat catWidth = CGRectGetMinX(countRect) - PBUI.cellMargin * 2;
    CGRect categoryRect = CGRectMake(PBUI.cellMargin, 6, catWidth, 30);
    self.categoryLabel.frame = categoryRect;
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
