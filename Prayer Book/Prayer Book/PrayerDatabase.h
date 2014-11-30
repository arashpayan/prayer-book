//
//  PrayerDatabase.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/25/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class PrayerView;

#import "Prayer.h"
#import "NSString_CategoryCompare.h"

extern NSString *const kBookmarksPrefKey;
extern NSString *const kRecentsPrefKey;

extern NSString *const kBookmarkKeyCategory;
extern NSString *const kBookmarkKeyTitle;

extern NSString *const kRecentsKeyCategory;
extern NSString *const kRecentsKeyTitle;
extern NSString *const kRecentsKeyAccessTime;

extern NSString *const kLanguageCzech;
extern NSString *const kLanguageDutch;
extern NSString *const kLanguageEnglish;
extern NSString *const kLanguageFrench;
extern NSString *const kLanguagePersian;
extern NSString *const kLanguageSpanish;
extern NSString *const kLanguageSlovak;

extern NSString *const PBNotificationLanguagesPreferenceChanged;

extern NSString *const kPrefsFontSize;

extern NSString* ISOCodeFromLanguage(NSString *language);

@interface PrayerDatabase : NSObject {
	sqlite3 *dbHandle;
}

@property(nonatomic, assign, getter=isPrayerBeingViewed) BOOL prayerBeingViewed;
@property(nonatomic, strong) PrayerView *prayerView;
@property (nonatomic, assign) BOOL showCzechPrayers;
@property (nonatomic, assign) BOOL showDutchPrayers;
@property (nonatomic, assign) BOOL showEnglishPrayers;
@property (nonatomic, assign) BOOL showFrenchPrayers;
@property (nonatomic, assign) BOOL showPersianPrayers;
@property (nonatomic, assign) BOOL showSpanishPrayers;
@property (nonatomic, assign) BOOL showSlovakPrayers;

+ (PrayerDatabase*)sharedInstance;
- (NSDictionary*)categories;
- (NSArray*)prayersForCategory:(NSString*)category language:(NSString*)language;
- (int)numberOfPrayersForCategory:(NSString*)category language:(NSString*)lang;
- (void)addBookmark:(long)prayerId;
- (BOOL)prayerIsBookmarked:(long)prayerId;
- (NSArray*)getBookmarks;
- (void)clearRecents;
- (NSArray*)getRecent;
- (void)accessedPrayer:(long)prayerId;
- (void)removeBookmark:(long)prayerId;
- (Prayer*)prayerWithId:(long)prayerId;
- (NSArray*)searchWithKeywords:(NSArray*)keywords;

- (void)migrateDbFromNilTo1;
- (void)migrateDbFrom1To2;
- (void)migrateDbFrom2To3;

@end
