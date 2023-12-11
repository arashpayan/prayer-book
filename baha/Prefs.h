//
//  Prefs.h
//  Prayer Book
//
//  Created by Arash Payan on 8/27/14.
//  Copyright (c) 2014 Arash Payan. All rights reserved.
//

@import Foundation;
@class PBLanguage;

extern NSString* const  NotificationThemeChanged;

@interface Prefs : NSObject

@property (nonatomic, readwrite) BOOL useClassicTheme;
+ (Prefs *)shared;
- (NSArray*)enabledLanguages;
- (BOOL)isLanguageEnabled:(PBLanguage*)lang;
- (void)setLanguage:(PBLanguage *)lang enabled:(BOOL)shouldEnable;

- (NSArray<NSNumber*> *)bookmarks;
- (void)bookmark:(long)prayerID;
- (void)deleteBookmark:(long)prayerID;
- (BOOL)isBookmarked:(long)prayerID;

@end
