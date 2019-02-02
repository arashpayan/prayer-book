//
//  PBUI.m
//  Prayer Book
//
//  Created by Arash Payan on 9/21/14.
//  Copyright (c) 2014 Arash Payan. All rights reserved.
//

#import "PBUI.h"

@implementation PBUI

+ (CGFloat)cellMargin {
    static CGFloat margin = 0;
    if (margin == 0) {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            margin = 18;
        } else {
            margin = 16;
        }
    }
    
    return margin;
}

@end
