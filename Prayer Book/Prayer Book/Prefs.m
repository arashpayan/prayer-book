//
//  Prefs.m
//  Prayer Book
//
//  Created by Arash Payan on 8/27/14.
//  Copyright (c) 2014 Arash Payan. All rights reserved.
//

#import "Prefs.h"
#import "PBLanguage.h"
#import "PrayerDatabase.h"


@implementation Prefs

static NSString *kPrefUseClassicTheme = @"PrefUseClassicTheme";

+ (Prefs *)shared {
    static Prefs *singleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [Prefs new];
    });

    return singleton;
}

- (NSArray*)enabledLanguages {
    NSMutableArray *langs = [NSMutableArray new];
    for (PBLanguage *l in PBLanguage.all) {
        if ([self isLanguageEnabled:l]) {
            [langs addObject:l];
        }
    }

    if (langs.count == 0) {
        // get the user's list of supported languages and find the first we support
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        for (NSString *pl in preferredLanguages) {
            BOOL foundLang = NO;    // to break out of the other loop
            for (PBLanguage *l in PBLanguage.all) {
                if ([pl hasPrefix:l.code]) {
                    [langs addObject:l];
                    foundLang = YES;
                    break;
                }
            }
            if (foundLang) {
                break;
            }
        }
    }

    // if it's still empty, just enable English
    if (langs.count == 0) {
        [langs addObject:PBLanguage.english];
    }

    return langs;
}

- (BOOL)isLanguageEnabled:(PBLanguage*)lang {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:lang.code];
}

- (void)setLanguage:(PBLanguage *)lang enabled:(BOOL)shouldEnable {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:shouldEnable forKey:lang.code];

    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@end
