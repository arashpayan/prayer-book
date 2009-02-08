//
//  RecentsTableCell.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentsTableCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *categoryLabel;
	
	UIColor *blackColor;
	UIColor *blueishColor;
	UIColor *whiteColor;
}

- (UILabel*)titleLabel;
- (UILabel*)categoryLabel;

@end
