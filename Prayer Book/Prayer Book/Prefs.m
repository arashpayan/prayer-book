//
//  Prefs.m
//  Prayer Book
//
//  Created by Arash Payan on 8/27/14.
//  Copyright (c) 2014 Arash Payan. All rights reserved.
//

#import "Prefs.h"


@implementation Prefs

static NSString *kPrefUseClassicTheme = @"PrefUseClassicTheme";

- (void)setUseClassicTheme:(BOOL)useClassicTheme {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setBool:useClassicTheme forKey:kPrefUseClassicTheme];
}

- (BOOL)useClassicTheme {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs boolForKey:kPrefUseClassicTheme];
}

@end
