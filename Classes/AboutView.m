//
//  AboutView.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "AboutView.h"


@implementation AboutView


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
	printf("x: %f y: %f w: %f h: %f\n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//float w, h;
//    w = rect.size.width;
//    h = rect.size.height;
//    CGAffineTransform myTextTransform; // 2
//    CGContextSelectFont (myContext, // 3
//						 "Times-Bold",
//						 h/10,
//						 kCGEncodingMacRoman);
//    CGContextSetCharacterSpacing (myContext, 10); // 4
//    CGContextSetTextDrawingMode (myContext, kCGTextFillStroke); // 5
//    CGContextSetRGBFillColor (myContext, 0, 1, 0, .5); // 6
//    CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 1); // 7
//    myTextTransform =  CGAffineTransformMakeRotation  (-.77); // 8
//    CGContextSetTextMatrix (myContext, myTextTransform); // 9
//    CGContextShowTextAtPoint (myContext, 40, 0, "Quartz 2D", 9); // 10
	
	char* text = "TrailsintheSand.com";
    CGContextSelectFont(ctx, "Helvetica", 24.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 0, 255, 255, 1);
	
    CGAffineTransform xform = CGAffineTransformMake(
													1.0,  0.0,
													0.0, -1.0,
													0.0,  0.0);
    CGContextSetTextMatrix(ctx, xform);
	
    CGContextShowTextAtPoint(ctx, 10, 300, text, strlen(text));
}


- (void)dealloc {
	[super dealloc];
}


@end
