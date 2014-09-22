//
//  CategoryCell.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectangleView.h"


@interface CategoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) RoundedRectangleView *roundedRectangle;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCategory:(NSString*)aCategory;
- (void)setCount:(NSString*)aCount;

@end
