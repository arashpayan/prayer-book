//
//  RoundedRectangleView.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundedRectangleView : UIView {
	float radius;
	BOOL highlighted;
}

- (void)setHighlighted:(BOOL)isHighlighted;

@end
