//
//  PrayerDatabase.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/25/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Prayer.h"
#import "PBLanguage.h"
#import "NSString_CategoryCompare.h"

extern NSString *const kBookmarksPrefKey;
extern NSString *const kRecentsPrefKey;

extern NSString *const kBookmarkKeyCategory;
extern NSString *const kBookmarkKeyTitle;

extern NSString *const kRecentsKeyCategory;
extern NSString *const kRecentsKeyTitle;

extern NSString *const PBNotificationLanguagesPreferenceChanged;

extern NSString *const kPrefsFontSize;

@interface PrayerDatabase : NSObject {
	sqlite3 *dbHandle;
}

+ (PrayerDatabase*)sharedInstance;
- (NSArray*)categoriesForLanguage:(PBLanguage *)aLanguage;
- (NSArray*)prayersForCategory:(NSString*)category language:(PBLanguage *)language;
- (int)numberOfPrayersForCategory:(NSString*)category language:(PBLanguage *)lang;
- (void)clearRecents;
- (NSArray*)recents;
- (void)accessedPrayer:(long)prayerId;
- (Prayer*)prayerWithId:(long)prayerId;
- (NSArray<Prayer*>*)searchWithKeywords:(NSArray*)keywords;

- (void)migrateDbFromNilTo1;
- (void)migrateDbFrom1To2;
- (void)migrateDbFrom2To3;

@end
