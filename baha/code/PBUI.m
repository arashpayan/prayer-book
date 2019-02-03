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

+ (void)installTheme {
    UITabBar.appearance.barTintColor = PBUI.blue;
    UITabBar.appearance.tintColor = PBUI.yellow;
    UITabBar.appearance.unselectedItemTintColor = UIColor.whiteColor;
    
    UINavigationBar.appearance.barStyle = UIBarStyleBlack;
    UINavigationBar.appearance.barTintColor = PBUI.blue;
    UINavigationBar.appearance.tintColor = UIColor.whiteColor;
    
    UISearchBar.appearance.barStyle = UIBarStyleBlack;
    UISearchBar.appearance.barTintColor = PBUI.blue;
    UISearchBar.appearance.tintColor = UIColor.whiteColor;
    
    UIToolbar.appearance.barStyle = UIBarStyleBlack;
    UIToolbar.appearance.barTintColor = PBUI.blue;
    UIToolbar.appearance.tintColor = UIColor.whiteColor;
}

#pragma mark - Brand colors

+ (UIColor*)blue {
    return [UIColor colorWithRed:0 green:61.0/255.0 blue:107.0/255.0 alpha:1];
}

+ (UIColor*)yellow {
    return [UIColor colorWithRed:1 green:195.0/255.0 blue:37.0/255.0 alpha:1];
}

@end
