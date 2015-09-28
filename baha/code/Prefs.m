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

NSString* const NotificationThemeChanged = @"sh.ara.ThemeChanged";

@implementation Prefs

#define USE_CLASSIC_THEME @"UseClassicTheme"
#define BOOKMARKS_PREF @"BookmarksPrefKey"

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

- (BOOL)useClassicTheme {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:USE_CLASSIC_THEME];
}

- (void)setUseClassicTheme:(BOOL)useClassicTheme {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:useClassicTheme forKey:USE_CLASSIC_THEME];
}

- (NSArray *)bookmarks {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *bookmarks = [ud objectForKey:BOOKMARKS_PREF];
    return bookmarks;
}

- (void)bookmark:(long)prayerID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *bookmarks = [[ud objectForKey:BOOKMARKS_PREF] mutableCopy];
    if (bookmarks == nil) {
        bookmarks = [NSMutableArray new];
    }
    [bookmarks addObject:@(prayerID)];
    [ud setObject:bookmarks forKey:BOOKMARKS_PREF];
    [ud synchronize];
}

- (void)deleteBookmark:(long)prayerID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *bookmarks = [[ud objectForKey:BOOKMARKS_PREF] mutableCopy];
    [bookmarks removeObject:@(prayerID)];
    [ud setObject:bookmarks forKey:BOOKMARKS_PREF];
    [ud synchronize];
}

- (BOOL)isBookmarked:(long)prayerID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *bookmarks = [[ud objectForKey:BOOKMARKS_PREF] mutableCopy];
    return [bookmarks containsObject:@(prayerID)];
}

@end
