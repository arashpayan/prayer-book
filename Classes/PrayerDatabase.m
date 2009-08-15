//
//  PrayerDatabase.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/25/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerDatabase.h"


NSString *const kBookmarksPrefKey			= @"BookmarksPrefKey";
NSString *const kRecentsPrefKey				= @"RecentsPrefKey";

NSString *const kBookmarkKeyCategory		= @"BookmarkKeyCategory";
NSString *const kBookmarkKeyTitle			= @"BookmarkKeyTitle";

NSString *const kRecentsKeyCategory			= @"RecentsKeyCategory";
NSString *const kRecentsKeyTitle			= @"RecentsKeyTitle";
NSString *const kRecentsKeyAccessTime		= @"RecentsKeyAccessTime";

NSString *const kPrefsFontSize				= @"fontSizePref";

NSString *const kDatabaseVersionNumber		= @"DatabaseVersionNumber";

@implementation PrayerDatabase

@synthesize prayerBeingViewed;
@synthesize prayerView;

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
		
		NSNumber *dbVersion = [(NSString*)CFPreferencesCopyAppValue((CFStringRef)kDatabaseVersionNumber, kCFPreferencesCurrentApplication) autorelease];
		if (dbVersion == nil)
		{
			[self migrateDbFromNilTo1];
			[self migrateDbFrom1To2];
			[self migrateDbFrom2To3];
		}
		else if ([dbVersion isEqualToNumber:[NSNumber numberWithInt:1]])
		{
			[self migrateDbFrom1To2];
			[self migrateDbFrom2To3];
		}
		else if ([dbVersion isEqualToNumber:[NSNumber numberWithInt:2]])
		{
			[self migrateDbFrom2To3];
		}
		
		// check for manually enable languages
		languages = [[NSMutableArray alloc] init];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		if ([userDefaults boolForKey:@"kEnglishEnabled"])
			[languages addObject:@"en"];
		if ([userDefaults boolForKey:@"kSpanishEnabled"])
			[languages addObject:@"es"];
		if ([userDefaults boolForKey:@"kFrenchEnabled"])
			[languages addObject:@"fr"];
		
		// if no languages was enabled, try and enable a language based on their preferrences
		if ([languages count] == 0)
		{
			// find the first language that we support
			NSArray *preferredLanguages = [NSLocale preferredLanguages];
			for (NSString *lang in preferredLanguages)
			{
				if ([lang isEqualToString:@"en"])
				{
					[languages addObject:@"en"];
					break;
				}
				else if ([lang isEqualToString:@"es"])
				{
					[languages addObject:@"es"];
					break;
				}
				else if ([lang isEqualToString:@"fr"])
				{
					[languages addObject:@"fr"];
					break;
				}
			}
		}
		
		// in the odd case that nothing could be found
		if ([languages count] == 0)
			[languages addObject:@"en"];
		
		languageSQL = [[NSMutableString alloc] init];
		for (int i=0; i<[languages count]; i++)
		{
			if (i == [languages count]-1)
				[languageSQL appendFormat:@"language='%@'", [languages objectAtIndex:i]];
			else
				[languageSQL appendFormat:@"language='%@' OR ", [languages objectAtIndex:i]];
			
		}
		
		// initialize the empty category count cache
		categoryCountCache = [[NSMutableDictionary alloc] init];
		
		// cache in the bookmarks and recents
		[self getBookmarks];
		[self getRecent];
	}
	
	return self;
}

- (void)migrateDbFromNilTo1 {
	// check for bookmarks
	NSArray *bookmarks = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)kBookmarksPrefKey, kCFPreferencesCurrentApplication);
	if (bookmarks != nil)
	{
		NSMutableArray *newBookmarks = [NSMutableArray arrayWithCapacity:10];
		for (NSDictionary *bookmark in bookmarks)
		{
			NSString *category = [bookmark objectForKey:kBookmarkKeyCategory];
			NSString *title = [bookmark objectForKey:kBookmarkKeyTitle];
			
			NSString *searchForPrayerSQL = [NSString stringWithFormat:@"SELECT id FROM prayers WHERE category='%@' AND openingWords='%@'", category, title];
			sqlite3_stmt *searchStmt;
			
			sqlite3_prepare_v2(dbHandle,
							   [searchForPrayerSQL UTF8String],
							   [searchForPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
							   &searchStmt,
							   0);
			int rc = sqlite3_step(searchStmt);
			if (rc == SQLITE_ROW)
			{
				long prayerId = sqlite3_column_int(searchStmt, 0);
				[newBookmarks addObject:[NSNumber numberWithInt:prayerId]];
			}
			
			sqlite3_finalize(searchStmt);
		}
		
		CFPreferencesSetAppValue((CFStringRef)kBookmarksPrefKey, newBookmarks, kCFPreferencesCurrentApplication);
		
		CFRelease(bookmarks);	// release the preference we retrieved
	}
	
	// check for recents
	NSArray *recents = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)kRecentsPrefKey, kCFPreferencesCurrentApplication);
	if (recents != nil)
	{
		NSMutableArray *newRecents = [NSMutableArray arrayWithCapacity:50];
		for (NSDictionary *recent in recents)
		{
			NSString *category = [recent objectForKey:kRecentsKeyCategory];
			NSString *title = [recent objectForKey:kRecentsKeyTitle];
			
			NSString *searchForPrayerSQL = [NSString stringWithFormat:@"SELECT id FROM prayers WHERE category='%@' AND openingWords='%@'", category, title];
			sqlite3_stmt *searchStmt;
			
			sqlite3_prepare_v2(dbHandle,
							   [searchForPrayerSQL UTF8String],
							   [searchForPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
							   &searchStmt,
							   0);
			
			int rc = sqlite3_step(searchStmt);
			if (rc == SQLITE_ROW)
			{
				long prayerId = sqlite3_column_int(searchStmt, 0);
				[newRecents addObject:[NSNumber numberWithInt:prayerId]];
			}
				
				sqlite3_finalize(searchStmt);
		}
		
		CFPreferencesSetAppValue((CFStringRef)kRecentsPrefKey, newRecents, kCFPreferencesCurrentApplication);
		
		CFRelease(recents);	// release the preferences we retrieved
	}
	
	CFPreferencesSetAppValue((CFStringRef)kDatabaseVersionNumber, [NSNumber numberWithInt:1], kCFPreferencesCurrentApplication);
}

- (void)migrateDbFrom1To2 {
	
	// fix the bug that caused the app to crash at launch in v1.1
	NSMutableArray *saveState = [[NSMutableArray alloc] init];
	[saveState addObject:[NSNumber numberWithInt:0]];
	CFPreferencesSetAppValue((CFStringRef)@"savedState", saveState, kCFPreferencesCurrentApplication);
	
	// update our db version number
	CFPreferencesSetAppValue((CFStringRef)kDatabaseVersionNumber, [NSNumber numberWithInt:2], kCFPreferencesCurrentApplication);
}

- (void)migrateDbFrom2To3 {
	// set the font size multiple to 1.0 (because it may have been some weird number due to the previous version
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:1.0 forKey:kPrefsFontSize];
	
	// update our db version number
	CFPreferencesSetAppValue((CFStringRef)kDatabaseVersionNumber, [NSNumber numberWithInt:3], kCFPreferencesCurrentApplication);
	
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

- (NSArray*)getCategories {
	NSMutableArray *categories = [[[NSMutableArray alloc] init] autorelease];
	NSString *getCategoriesSQL = [NSString stringWithFormat:@"SELECT DISTINCT category FROM prayers WHERE %@", languageSQL];

//	NSLog(getCategoriesSQL);

	sqlite3_stmt *getCategoriesStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getCategoriesSQL UTF8String],
								[getCategoriesSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&getCategoriesStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing getCategoriesStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	while ((rc = sqlite3_step(getCategoriesStmt)) == SQLITE_ROW)
	{
		[categories addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(getCategoriesStmt, 0)]];
	}
	
	sqlite3_finalize(getCategoriesStmt);
	
	NSArray *sortedCategories = [categories sortedArrayUsingSelector:@selector(compareCategories:)];
	
	return sortedCategories;
}

- (NSArray*)getPrayersForCategory:(NSString*)category {
	if (category == nil)
		return nil;
	
	// escape any single quotes
	category = [category stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	NSMutableArray *prayers = [[NSMutableArray alloc] init];
	NSString *getPrayersSQL = [NSString stringWithFormat:@"SELECT id, prayerText, openingWords, citation, author, language, wordCount FROM prayers WHERE category='%@'", category];
	sqlite3_stmt *getPrayersStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getPrayersSQL UTF8String],
								[getPrayersSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&getPrayersStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing getPrayersStmt in getPrayersForCategory (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	while ((rc = sqlite3_step(getPrayersStmt)) == SQLITE_ROW)
	{
		long prayerId = sqlite3_column_int(getPrayersStmt, 0);
		NSString *prayerText = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 1)];
		NSString *openingWords = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 2)];
		NSString *citation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 3)];
		NSString *author = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 4)];
		NSString *language = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayersStmt, 5)];
		int wordCount = sqlite3_column_int(getPrayersStmt, 6);
		Prayer *prayer = [[[Prayer alloc] initWithCategory:category withText:prayerText withOpeningWords:openingWords] autorelease];
		prayer.citation = citation;
		prayer.author = author;
		[prayer setAuthor:author];
		prayer.language = language;
		prayer.prayerId = prayerId;
		prayer.wordCount = [[NSNumber numberWithInt:wordCount] stringValue];
		
		[prayers addObject:prayer];
	}
	
	sqlite3_finalize(getPrayersStmt);
	
	return [prayers autorelease];
}

- (int)numberOfPrayersForCategory:(NSString*)category {
	if (category == nil)
		return -1;
	
	NSNumber *cachedCount = [categoryCountCache objectForKey:category];
	if (cachedCount != nil)
		return [cachedCount intValue];
	
	int numPrayers = 0;
	
	NSString *countPrayersSQL = [NSString stringWithFormat:@"SELECT COUNT(id) FROM prayers WHERE category=\"%@\"", category];
	sqlite3_stmt *countPrayersStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[countPrayersSQL UTF8String],
								[countPrayersSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
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
	[categoryCountCache setObject:[NSNumber numberWithInt:numPrayers] forKey:category];
	
	return numPrayers;
}

- (NSArray*)getBookmarks {
	if (bookmarkedPrayers == nil)
	{
		NSArray *tmp = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)kBookmarksPrefKey, kCFPreferencesCurrentApplication);
		
		if (tmp == nil)
		{
			// if there is no bookmark list, we'll make an empty one
			bookmarkedPrayers = [[NSMutableArray alloc] init];
		}
		else
		{
			bookmarkedPrayers = [NSMutableArray arrayWithCapacity:[tmp count]];
			[bookmarkedPrayers retain];
			[bookmarkedPrayers addObjectsFromArray:tmp];
			CFRelease(tmp);
		}
	}
	
	return [NSArray arrayWithArray:bookmarkedPrayers];
}

- (BOOL)prayerIsBookmarked:(long)prayerId {	
	return [bookmarkedPrayers containsObject:[NSNumber numberWithLong:prayerId]];
}

- (void)addBookmark:(long)prayerId {
	[bookmarkedPrayers addObject:[NSNumber numberWithLong:prayerId]];
	
	CFPreferencesSetAppValue((CFStringRef)kBookmarksPrefKey, bookmarkedPrayers, kCFPreferencesCurrentApplication);
}

- (void)removeBookmark:(long)prayerId {
	[bookmarkedPrayers removeObject:[NSNumber numberWithLong:prayerId]];
	
	CFPreferencesSetAppValue((CFStringRef)kBookmarksPrefKey, bookmarkedPrayers, kCFPreferencesCurrentApplication);
}

- (void)clearRecents {
	[recentPrayers release];
	recentPrayers = [[NSMutableArray alloc] init];
	
	CFPreferencesSetAppValue((CFStringRef)kRecentsPrefKey, nil, kCFPreferencesCurrentApplication);
}

- (NSArray*)getRecent {
	if (recentPrayers == nil)
	{
		NSArray *tmp = (NSArray*)CFPreferencesCopyAppValue((CFStringRef)kRecentsPrefKey, kCFPreferencesCurrentApplication);

		if (tmp == nil)
		{
			// if there is no recent list, we'll make an empty one
			recentPrayers = [[NSMutableArray alloc] init];
		}
		else
		{
			recentPrayers = [NSMutableArray arrayWithCapacity:[tmp count]];
			[recentPrayers retain];
			[recentPrayers addObjectsFromArray:tmp];
			CFRelease(tmp);
		}
	}
	
	return [NSArray arrayWithArray:recentPrayers];
}


- (void)accessedPrayer:(long)prayerId {
	NSNumber *entry = [NSNumber numberWithLong:prayerId];
	
	[recentPrayers removeObject:entry];	// if it's even there
	[recentPrayers insertObject:entry atIndex:0];
	
	CFPreferencesSetAppValue((CFStringRef)kRecentsPrefKey, recentPrayers, kCFPreferencesCurrentApplication);
}

- (Prayer*)prayerWithId:(long)prayerId {
	NSString *getPrayerSQL = [NSString stringWithFormat:@"SELECT category, prayerText, openingWords, citation, author, language, wordCount FROM prayers WHERE id=%d", prayerId];
	sqlite3_stmt *getPrayerStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getPrayerSQL UTF8String],
								[getPrayerSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&getPrayerStmt,
								0);
	
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing getPrayerStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	Prayer *prayer = nil;
	rc = sqlite3_step(getPrayerStmt);
	if (rc == SQLITE_ROW)
	{
		prayer = [[Prayer alloc] init];
		prayer.category = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 0)];
		prayer.text = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 1)];
		prayer.title = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 2)];
		prayer.citation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 3)];
		prayer.author = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 4)];
		prayer.language = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getPrayerStmt, 5)];
		prayer.wordCount = [[NSNumber numberWithInt:sqlite3_column_int(getPrayerStmt, 6)] stringValue];
		prayer.prayerId = prayerId;
	}
	
	sqlite3_finalize(getPrayerStmt);
	
	return [prayer autorelease];
}

- (NSArray*)searchWithKeywords:(NSArray*)keywords {
	static NSMutableDictionary *prayerCache = nil;
	if (prayerCache == nil)
		prayerCache = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	
	// build a query with the keywords
	NSMutableString *query = [[[NSMutableString alloc] init] autorelease];
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
		if ([[expressions objectAtIndex:0] lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 3)
			return results;	// this is too short of a query, so exit
	}
	
	// now limit our search by language
	[query appendFormat:@" AND (%@)", languageSQL];
	
	//NSLog(query);
	
	sqlite3_stmt *searchStmt;
	int rc = sqlite3_prepare_v2(dbHandle,
								[query UTF8String],
								[query lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								&searchStmt,
								0);
	if (rc != SQLITE_OK)
		NSLog(@"Problem preparing searchWithKeywordsStmt (%d): %s", rc, sqlite3_errmsg(dbHandle));
	
	while ((rc = sqlite3_step(searchStmt)) == SQLITE_ROW)
	{
		NSNumber *prayerId = [NSNumber numberWithLong:sqlite3_column_int(searchStmt, 0)];
		// check for it in the cache
		Prayer *currPrayer = nil;
		if ((currPrayer = (Prayer*)[prayerCache objectForKey:prayerId]) == nil)
		{
			currPrayer = [self prayerWithId:[prayerId longValue]];
			// cache it
			[prayerCache setObject:currPrayer forKey:prayerId];
		}
		
		[results addObject:currPrayer];
	}
	
	return results;
}

- (void) dealloc
{
	[languages release];
	[languageSQL release];
	[categoryCountCache release];
	
	[super dealloc];
}


@end
