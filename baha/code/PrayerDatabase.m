//
//  PrayerDatabase.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/25/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerDatabase.h"
#import "Prefs.h"


NSString *const kBookmarksPrefKey			= @"BookmarksPrefKey";
NSString *const kRecentsPrefKey				= @"RecentsPrefKey";

NSString *const kBookmarkKeyCategory		= @"BookmarkKeyCategory";
NSString *const kBookmarkKeyTitle			= @"BookmarkKeyTitle";

NSString *const kRecentsKeyCategory			= @"RecentsKeyCategory";
NSString *const kRecentsKeyTitle			= @"RecentsKeyTitle";

NSString *const kPrefsFontSize				= @"fontSizePref";

NSString *const kDatabaseVersionNumber		= @"DatabaseVersionNumber";

NSString *const PBNotificationLanguagesPreferenceChanged    = @"PBNotificationLanguagesPreferenceChanged";

@interface PrayerDatabase ()

@property (nonatomic, strong) NSMutableDictionary *categoryCountCache;
@property (nonatomic, strong) NSMutableArray *recentPrayers;

@end

@implementation PrayerDatabase

- (id)init {
	self = [super init];
	if (self)
	{
		// get the path to the prayers database
		NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"pbdb" ofType:@"db"];
		int rc = sqlite3_open([dbPath UTF8String], &dbHandle);
		if (rc != SQLITE_OK)
		{
			NSLog(@"Can't open the database: %s", sqlite3_errmsg(dbHandle));
		}
		
		NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kDatabaseVersionNumber];
        switch (dbVersion) {
            case 0:
                [self migrateDbFromNilTo1];
            case 1:
                [self migrateDbFrom1To2];
            case 2:
                [self migrateDbFrom2To3];
            default:
                break;
        }

		// initialize the empty category count cache
		self.categoryCountCache = [[NSMutableDictionary alloc] init];
		
		// cache the recents
		[self getRecent];
	}
	
	return self;
}

- (void)migrateDbFromNilTo1 {
	// check for bookmarks
	NSArray *bookmarks = [[NSUserDefaults standardUserDefaults] arrayForKey:kBookmarksPrefKey];
	if (bookmarks != nil) {
		NSMutableArray *newBookmarks = [NSMutableArray arrayWithCapacity:10];
		for (NSDictionary *bookmark in bookmarks) {
			NSString *category = bookmark[kBookmarkKeyCategory];
			NSString *title = bookmark[kBookmarkKeyTitle];
			
			NSString *searchForPrayerSQL = [NSString stringWithFormat:@"SELECT id FROM prayers WHERE category='%@' AND openingWords='%@'", category, title];
			sqlite3_stmt *searchStmt;
			
			sqlite3_prepare_v2(dbHandle,
							   [searchForPrayerSQL UTF8String],
							   (int)[searchForPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
							   &searchStmt,
							   0);
			int rc = sqlite3_step(searchStmt);
			if (rc == SQLITE_ROW) {
				long prayerId = sqlite3_column_int(searchStmt, 0);
				[newBookmarks addObject:@(prayerId)];
			}
			
			sqlite3_finalize(searchStmt);
		}
		
        [[NSUserDefaults standardUserDefaults] setObject:newBookmarks forKey:kBookmarksPrefKey];
	}
	
	// check for recents
	NSArray *recents = [[NSUserDefaults standardUserDefaults] arrayForKey:kRecentsPrefKey];
	if (recents != nil)
	{
		NSMutableArray *newRecents = [NSMutableArray arrayWithCapacity:50];
		for (NSDictionary *recent in recents)
		{
			NSString *category = recent[kRecentsKeyCategory];
			NSString *title = recent[kRecentsKeyTitle];
			
			NSString *searchForPrayerSQL = [NSString stringWithFormat:@"SELECT id FROM prayers WHERE category='%@' AND openingWords='%@'", category, title];
			sqlite3_stmt *searchStmt;
			
			sqlite3_prepare_v2(dbHandle,
							   [searchForPrayerSQL UTF8String],
							   (int)[searchForPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
							   &searchStmt,
							   0);
			
			int rc = sqlite3_step(searchStmt);
			if (rc == SQLITE_ROW)
			{
				long prayerId = sqlite3_column_int(searchStmt, 0);
				[newRecents addObject:@(prayerId)];
			}
				
				sqlite3_finalize(searchStmt);
		}
		
        [[NSUserDefaults standardUserDefaults] setObject:newRecents forKey:kRecentsPrefKey];
	}
	
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kDatabaseVersionNumber];
}

- (void)migrateDbFrom1To2 {
	
	// fix the bug that caused the app to crash at launch in v1.1
	NSMutableArray *saveState = [[NSMutableArray alloc] init];
	[saveState addObject:@0];
    [[NSUserDefaults standardUserDefaults] setObject:saveState forKey:@"savedState"];
	
	// update our db version number
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kDatabaseVersionNumber];
}

- (void)migrateDbFrom2To3 {
	// set the font size multiple to 1.0 (because it may have been some weird number due to the previous version
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:1.0 forKey:kPrefsFontSize];
	
	// update our db version number
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:kDatabaseVersionNumber];
	
	NSLog(@"migratedDBFrom2To3");
}

+ (PrayerDatabase*)sharedInstance {
	static PrayerDatabase *prayerDatabase;
	
	if (prayerDatabase == nil)
	{
		@synchronized(self)
		{
			if (prayerDatabase == nil)
				prayerDatabase = [[PrayerDatabase alloc] init];
		}
	}
	
	return prayerDatabase;
}

- (NSArray*)categoriesForLanguage:(PBLanguage *)aLanguage {
	NSMutableArray *categories = [[NSMutableArray alloc] init];
	NSString *categoriesSQL = [NSString stringWithFormat:@"SELECT DISTINCT category FROM prayers WHERE language='%@' ORDER BY category ASC", aLanguage.code];
	
	sqlite3_stmt *categoriesStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[categoriesSQL UTF8String],
								(int)[categoriesSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&categoriesStmt,
								0);
	
	if (rc != SQLITE_OK)
	{
		NSLog(@"Problem preparing categoriesForLanguageStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
		return categories;
	}
	
	while (sqlite3_step(categoriesStmt) == SQLITE_ROW)
	{
		[categories addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(categoriesStmt, 0)]];
	}
	
	sqlite3_finalize(categoriesStmt);

    return categories;
}

- (NSArray*)prayersForCategory:(NSString*)category language:(PBLanguage *)language {
    if (category == nil) {
		return nil;
    }
	
	NSMutableArray *prayers = [[NSMutableArray alloc] init];
	NSString *getPrayersSQL = [NSString stringWithFormat:@"SELECT id, prayerText, openingWords, citation, author, wordCount FROM prayers WHERE category=\"%@\" AND language=\"%@\"", category, language.code];
	sqlite3_stmt *getPrayersStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getPrayersSQL UTF8String],
								(int)[getPrayersSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&getPrayersStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing getPrayersStmt in getPrayersForCategory (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	while (sqlite3_step(getPrayersStmt) == SQLITE_ROW)
	{
		long prayerId = sqlite3_column_int(getPrayersStmt, 0);
		NSString *prayerText = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 1)];
		NSString *openingWords = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 2)];
		NSString *citation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 3)];
		NSString *author = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 4)];
		int wordCount = sqlite3_column_int(getPrayersStmt, 5);
		Prayer *prayer = [[Prayer alloc] initWithCategory:category withText:prayerText withOpeningWords:openingWords];
		prayer.citation = citation;
		prayer.author = author;
		[prayer setAuthor:author];
		prayer.language = language;
		prayer.prayerId = prayerId;
		prayer.wordCount = @(wordCount).stringValue;
		
		[prayers addObject:prayer];
	}
	
	sqlite3_finalize(getPrayersStmt);
	
	return prayers;
}

- (int)numberOfPrayersForCategory:(NSString*)category language:(PBLanguage *)lang {
    if (self.categoryCountCache[category] != nil) {
        NSNumber *n = self.categoryCountCache[category];
        return n.intValue;
    }

	int numPrayers = 0;
	
	NSString *countPrayersSQL = [NSString stringWithFormat:@"SELECT COUNT(id) FROM prayers WHERE category=\"%@\" AND language=\"%@\"", category, lang];
	sqlite3_stmt *countPrayersStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[countPrayersSQL UTF8String],
								(int)[countPrayersSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&countPrayersStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing countPrayersStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	rc = sqlite3_step(countPrayersStmt);
	if (rc == SQLITE_ROW)
		numPrayers = sqlite3_column_int(countPrayersStmt, 0);
	else
		NSLog(@"Problem obtaining result from countPrayersStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	sqlite3_finalize(countPrayersStmt);
	
	// cache it for future reference
	self.categoryCountCache[category] = @(numPrayers);
	
	return numPrayers;
}

- (void)clearRecents {
	self.recentPrayers = [[NSMutableArray alloc] init];
	
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kRecentsPrefKey];
}

- (NSArray*)getRecent {
	if (self.recentPrayers == nil) {
        NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentsPrefKey];

		if (tmp == nil) {
			// if there is no recent list, we'll make an empty one
			self.recentPrayers = [[NSMutableArray alloc] init];
		} else {
			self.recentPrayers = [NSMutableArray arrayWithCapacity:[tmp count]];
			[self.recentPrayers addObjectsFromArray:tmp];
		}
	}
	
	return [NSArray arrayWithArray:self.recentPrayers];
}


- (void)accessedPrayer:(long)prayerId {
	NSNumber *entry = @(prayerId);
	
	[self.recentPrayers removeObject:entry];	// if it's even there
	[self.recentPrayers insertObject:entry atIndex:0];
	
    [[NSUserDefaults standardUserDefaults] setObject:self.recentPrayers forKey:kRecentsPrefKey];
}

- (Prayer*)prayerWithId:(long)prayerId {
	NSString *getPrayerSQL = [NSString stringWithFormat:@"SELECT category, prayerText, openingWords, citation, author, language, wordCount FROM prayers WHERE id=%ld", prayerId];
	sqlite3_stmt *getPrayerStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getPrayerSQL UTF8String],
								(int)[getPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&getPrayerStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing getPrayerStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	Prayer *prayer = nil;
	rc = sqlite3_step(getPrayerStmt);
	if (rc == SQLITE_ROW)
	{
		prayer = [Prayer new];
		prayer.category = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 0)];
		prayer.text = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 1)];
		prayer.title = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 2)];
		prayer.citation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 3)];
		prayer.author = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 4)];
        NSString *langCode = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 5)];
        prayer.language = [PBLanguage languageFromCode:langCode];
		prayer.wordCount = @(sqlite3_column_int(getPrayerStmt, 6)).stringValue;
		prayer.prayerId = prayerId;
	}
	
	sqlite3_finalize(getPrayerStmt);
	
	return prayer;
}

- (NSArray*)searchWithKeywords:(NSArray*)keywords {
	static NSMutableDictionary *prayerCache = nil;
	if (prayerCache == nil)
		prayerCache = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *results = [[NSMutableArray alloc] init];
	
	// build a query with the keywords
	NSMutableString *query = [[NSMutableString alloc] init];
	[query appendString:@"SELECT id FROM prayers WHERE"];
	NSMutableArray *expressions = [NSMutableArray arrayWithCapacity:5];
	BOOL firstExpression = YES;
	for (NSString *keyword in keywords)
	{
		if ([keyword lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0)
			continue;
		if (!firstExpression)
			[query appendFormat:@" AND"];
		else
			firstExpression = NO;
		
		[query appendFormat:@" searchText LIKE '%%%@%%'", keyword];
		[expressions addObject:keyword];
	}
	
	if ([expressions count] == 0)
	{
		// means there were no valid keywords, and we need to return an empty set of results
		return results;
	}
	else if ([expressions count] == 1)
	{
		if ([expressions[0] lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 3)
			return results;	// this is too short of a query, so exit
	}
	
	// now limit our search by language
    NSMutableString *langClause = [NSMutableString new];
    NSArray *enabledLangs = Prefs.shared.enabledLanguages;
    for (int i=0; i<enabledLangs.count; i++) {
        PBLanguage *l = enabledLangs[(NSUInteger) i];
        if (i == enabledLangs.count-1) {
            [langClause appendFormat:@"language='%@'", l.code];
        } else {
            [langClause appendFormat:@"language='%@' OR ", l.code];
        }
    }
	[query appendFormat:@" AND (%@)", langClause];
	
	//NSLog(query);
	
	sqlite3_stmt *searchStmt;
	int rc = sqlite3_prepare_v2(dbHandle,
								[query UTF8String],
								(int)[query lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&searchStmt,
								0);
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing searchWithKeywordsStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	while (sqlite3_step(searchStmt) == SQLITE_ROW)
	{
		NSNumber *prayerId = @(sqlite3_column_int(searchStmt, 0));
		// check for it in the cache
		Prayer *currPrayer = nil;
		if ((currPrayer = (Prayer*)prayerCache[prayerId]) == nil)
		{
			currPrayer = [self prayerWithId:[prayerId longValue]];
			// cache it
			prayerCache[prayerId] = currPrayer;
		}
		
		[results addObject:currPrayer];
	}
	
	return results;
}

@end
