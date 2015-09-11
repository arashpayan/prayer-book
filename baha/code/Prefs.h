//
//  Prefs.h
//  Prayer Book
//
//  Created by Arash Payan on 8/27/14.
//  Copyright (c) 2014 Arash Payan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBLanguage;

@interface Prefs : NSObject

+ (Prefs *)shared;
- (NSArray*)enabledLanguages;
- (BOOL)isLanguageEnabled:(PBLanguage*)lang;
- (void)setLanguage:(PBLanguage *)lang enabled:(BOOL)shouldEnable;

@end
