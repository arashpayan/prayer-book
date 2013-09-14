//
//  RoundedRectangleView.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "RoundedRectangleView.h"


@implementation RoundedRectangleView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
		radius = 10;
		self.opaque = YES;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (!highlighted)
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	else
		CGContextSetRGBFillColor(context, 1, 1, 1, 0);
	CGContextFillRect(context, rect);
	
	if (!highlighted)
	{
		CGContextSetRGBFillColor(context, 140.0/255.0, 153.0/255.0, 180.0/255.0, 1);
		//CGContextSetRGBFillColor(context, 198.0/255.0, 41.0/255.0, 26.0/255.0, 1);
	}
	else
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	//CGContextFillEllipseInRect(context, rect);
	
	int xMin = CGRectGetMinX(rect);
	int xMax = CGRectGetMaxX(rect);
	int yMin = CGRectGetMinY(rect);
	int yMax = CGRectGetMaxY(rect);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, xMin+radius, yMin);
	
	// top-right corner
	CGContextAddLineToPoint(context, xMax - radius, yMin);
	CGContextAddCurveToPoint(context, xMax - radius, yMin, xMax, yMin, xMax, yMin + radius);
	
	// bottom-right corner
	CGContextAddLineToPoint(context, xMax, yMax - radius);
	CGContextAddCurveToPoint(context, xMax, yMax - radius, xMax, yMax, xMax - radius, yMax);
	
	// bottom-left corner
	CGContextAddLineToPoint(context, xMin + radius, yMax);
	CGContextAddCurveToPoint(context, xMin + radius, yMax, xMin, yMax, xMin, yMax - radius);
	
	// top-left corner
	CGContextAddLineToPoint(context, xMin, yMin + radius);
	CGContextAddCurveToPoint(context, xMin, yMin + radius, xMin, yMin, xMin + radius, yMin);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)setRadius:(float)aRadius {
	radius = aRadius;
}

- (BOOL)isHighlighted {
	return highlighted;
}

- (void)setHighlighted:(BOOL)isHighlighted {
	highlighted = isHighlighted;
}

@end
