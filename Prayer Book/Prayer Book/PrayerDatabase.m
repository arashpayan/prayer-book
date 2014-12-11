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

NSString *const kLanguageCzech              = @"cs";
NSString *const kLanguageDutch              = @"nl";
NSString *const kLanguageEnglish            = @"en";
NSString *const kLanguageFrench             = @"fr";
NSString *const kLanguagePersian            = @"fa";
NSString *const kLanguageSpanish            = @"es";
NSString *const kLanguageSlovak             = @"sk";

extern NSString* ISOCodeFromLanguage(NSString *language) {
    if ([language isEqualToString:@"English"]) {
        return @"en";
    }
    if ([language isEqualToString:@"Español"]) {
        return @"es";
    }
    if ([language isEqualToString:@"Français"]) {
        return @"fr";
    }
    if ([language isEqualToString:@"فارسی"]) {
        return @"fa";
    }
    if ([language isEqualToString:@"Nederlands"]) {
        return @"nl";
    }
    if ([language isEqualToString:@"Čeština"]) {
        return @"cs";
    }
    if ([language isEqualToString:@"Slovenčina"]) {
        return @"sk";
    }
    
    return @"";
}

NSString *const PBNotificationLanguagesPreferenceChanged    = @"PBNotificationLanguagesPreferenceChanged";

@interface PrayerDatabase ()

@property (nonatomic, strong) NSMutableArray *bookmarkedPrayers;
@property (nonatomic, strong) NSMutableDictionary *categoryCountCache;
@property (nonatomic, strong) NSMutableArray *languages;
@property (nonatomic, strong) NSMutableString *languageSQL;
@property (nonatomic, strong) NSMutableArray *recentPrayers;
- (void)buildLanguages;

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
		
		// check what languages are enabled
		self.languages = [[NSMutableArray alloc] init];
        self.languageSQL = [[NSMutableString alloc] init];
        _showCzechPrayers = NO;
        _showDutchPrayers = NO;
        _showEnglishPrayers = NO;
        _showFrenchPrayers = NO;
        _showPersianPrayers = NO;
        _showSpanishPrayers = NO;
        _showSlovakPrayers = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults boolForKey:kLanguageCzech]) {
            _showCzechPrayers = YES;
            [self.languages addObject:kLanguageCzech];
        }
        if ([userDefaults boolForKey:kLanguageDutch])
        {
            _showDutchPrayers = YES;
            [self.languages addObject:kLanguageDutch];
        }
        if ([userDefaults boolForKey:kLanguageEnglish])
        {
            _showEnglishPrayers = YES;
            [self.languages addObject:kLanguageEnglish];
        }
        if ([userDefaults boolForKey:kLanguageFrench])
        {
            _showFrenchPrayers = YES;
            [self.languages addObject:kLanguageFrench];
        }
        if ([userDefaults boolForKey:kLanguagePersian])
        {
            _showPersianPrayers = YES;
            [self.languages addObject:kLanguagePersian];
        }
        if ([userDefaults boolForKey:kLanguageSpanish])
        {
            _showSpanishPrayers = YES;
            [self.languages addObject:kLanguageSpanish];
        }
        if ([userDefaults boolForKey:kLanguageSlovak]) {
            _showSlovakPrayers = YES;
            [self.languages addObject:kLanguageSlovak];
        }
        
        // if no languages was enabled, try and enable a language based on their preferrences
        if ([self.languages count] == 0)
        {
            // find the first language that we support
            NSArray *preferredLanguages = [NSLocale preferredLanguages];
            for (NSString *lang in preferredLanguages)
            {
                if ([lang isEqualToString:kLanguageEnglish]) {
                    _showEnglishPrayers = YES;
                    [self.languages addObject:kLanguageEnglish];
                    break;
                } else if ([lang isEqualToString:kLanguageSpanish]) {
                    _showSpanishPrayers = YES;
                    [self.languages addObject:kLanguageSpanish];
                    break;
                } else if ([lang isEqualToString:kLanguageFrench]) {
                    _showFrenchPrayers = YES;
                    [self.languages addObject:kLanguageFrench];
                    break;
                } else if ([lang isEqualToString:kLanguageDutch]) {
                    _showDutchPrayers = YES;
                    [self.languages addObject:kLanguageDutch];
                    break;
                } else if ([lang isEqualToString:kLanguagePersian]) {
                    _showPersianPrayers = YES;
                    [self.languages addObject:kLanguagePersian];
                    break;
                } else if ([lang isEqualToString:kLanguageCzech]) {
                    _showCzechPrayers = YES;
                    [self.languages addObject:kLanguageCzech];
                    break;
                } else if ([lang isEqualToString:kLanguageSlovak]) {
                    _showSlovakPrayers = YES;
                    [self.languages addObject:kLanguageSlovak];
                    break;
                }
            }
        }
        
        // in the odd case that nothing could be found
        if ([self.languages count] == 0)
            self.showEnglishPrayers = YES;
        
        [self buildLanguages];
        
		
		// initialize the empty category count cache
		self.categoryCountCache = [[NSMutableDictionary alloc] init];
		
		// cache the bookmarks and recents
		[self getBookmarks];
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
			NSString *category = [bookmark objectForKey:kBookmarkKeyCategory];
			NSString *title = [bookmark objectForKey:kBookmarkKeyTitle];
			
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
				[newBookmarks addObject:[NSNumber numberWithLong:prayerId]];
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
			NSString *category = [recent objectForKey:kRecentsKeyCategory];
			NSString *title = [recent objectForKey:kRecentsKeyTitle];
			
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
				[newRecents addObject:[NSNumber numberWithLong:prayerId]];
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
	[saveState addObject:[NSNumber numberWithInt:0]];
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

- (NSArray*)categoriesForLanguage:(NSString*)aLanguage {
	NSMutableArray *categories = [[NSMutableArray alloc] init];
	NSString *categoriesSQL = [NSString stringWithFormat:@"SELECT DISTINCT category FROM prayers WHERE language='%@'", aLanguage];
	
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
	
	while ((rc = sqlite3_step(categoriesStmt)) == SQLITE_ROW)
	{
		[categories addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(categoriesStmt, 0)]];
	}
	
	sqlite3_finalize(categoriesStmt);
	
	NSArray *sortedCategories = [categories sortedArrayUsingSelector:@selector(compareCategories:)];
	
	return sortedCategories;
}

- (NSDictionary*)categories {
	NSMutableDictionary *categories = [[NSMutableDictionary alloc] init];
	for (NSString *lang in self.languages)
	{
		[categories setObject:[self categoriesForLanguage:lang] forKey:NSLocalizedString(lang, NULL)];
	}
	
	return categories;
}

- (NSArray*)prayersForCategory:(NSString*)category language:(NSString*)lang {
    lang = ISOCodeFromLanguage(lang);
    if (category == nil) {
		return nil;
    }
	
	NSMutableArray *prayers = [[NSMutableArray alloc] init];
	NSString *getPrayersSQL = [NSString stringWithFormat:@"SELECT id, prayerText, openingWords, citation, author, language, wordCount FROM prayers WHERE category=\"%@\" AND language=\"%@\"", category, lang];
	sqlite3_stmt *getPrayersStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getPrayersSQL UTF8String],
								(int)[getPrayersSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
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
		Prayer *prayer = [[Prayer alloc] initWithCategory:category withText:prayerText withOpeningWords:openingWords];
		prayer.citation = citation;
		prayer.author = author;
		[prayer setAuthor:author];
		prayer.language = language;
		prayer.prayerId = prayerId;
		prayer.wordCount = [[NSNumber numberWithInt:wordCount] stringValue];
		
		[prayers addObject:prayer];
	}
	
	sqlite3_finalize(getPrayersStmt);
	
	return prayers;
}

- (int)numberOfPrayersForCategory:(NSString*)category language:(NSString*)lang {
	int numPrayers = 0;
    lang = ISOCodeFromLanguage(lang);
	
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
	[self.categoryCountCache setObject:[NSNumber numberWithInt:numPrayers] forKey:category];
	
	return numPrayers;
}

- (NSArray*)getBookmarks {
	if (self.bookmarkedPrayers == nil) {
        NSArray *tmp = [[NSUserDefaults standardUserDefaults] arrayForKey:kBookmarksPrefKey];
		
		if (tmp == nil) {
			// if there is no bookmark list, we'll make an empty one
			self.bookmarkedPrayers = [[NSMutableArray alloc] init];
		} else {
			self.bookmarkedPrayers = [NSMutableArray arrayWithCapacity:[tmp count]];
			[self.bookmarkedPrayers addObjectsFromArray:tmp];
		}
	}
	
	return [NSArray arrayWithArray:self.bookmarkedPrayers];
}

- (BOOL)prayerIsBookmarked:(long)prayerId {	
	return [self.bookmarkedPrayers containsObject:[NSNumber numberWithLong:prayerId]];
}

- (void)addBookmark:(long)prayerId {
	[self.bookmarkedPrayers addObject:[NSNumber numberWithLong:prayerId]];
	
    [[NSUserDefaults standardUserDefaults] setObject:self.bookmarkedPrayers forKey:kBookmarksPrefKey];
}

- (void)removeBookmark:(long)prayerId {
	[self.bookmarkedPrayers removeObject:[NSNumber numberWithLong:prayerId]];
	
    [[NSUserDefaults standardUserDefaults] setObject:self.bookmarkedPrayers forKey:kBookmarksPrefKey];
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
	NSNumber *entry = [NSNumber numberWithLong:prayerId];
	
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
		if ([[expressions objectAtIndex:0] lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 3)
			return results;	// this is too short of a query, so exit
	}
	
	// now limit our search by language
	[query appendFormat:@" AND (%@)", self.languageSQL];
	
	//NSLog(query);
	
	sqlite3_stmt *searchStmt;
	int rc = sqlite3_prepare_v2(dbHandle,
								[query UTF8String],
								(int)[query lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
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

- (void)buildLanguages {
    // wipe out the current string, then rebuild the query
    [self.languageSQL setString:@""];
    for (int i=0; i<[self.languages count]; i++)
    {
        if (i == [self.languages count]-1)
            [self.languageSQL appendFormat:@"language='%@'", [self.languages objectAtIndex:i]];
        else
            [self.languageSQL appendFormat:@"language='%@' OR ", [self.languages objectAtIndex:i]];
        
    }
}

#pragma mark - Language accessors

@synthesize showCzechPrayers = _showCzechPrayers;
- (void)setShowCzechPrayers:(BOOL)shouldShowCzechPrayers {
    if (_showCzechPrayers == shouldShowCzechPrayers) {
        return;
    }
    
    _showCzechPrayers = shouldShowCzechPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showCzechPrayers forKey:kLanguageCzech];
    [userDefaults synchronize];
    
    if (_showCzechPrayers) {
        [self.languages addObject:kLanguageCzech];
    } else {
        [self.languages removeObject:kLanguageCzech];
    }
    
    if ([self.languages count] == 0) {
        self.showEnglishPrayers = YES;
    }
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showDutchPrayers = _showDutchPrayers;
- (void)setShowDutchPrayers:(BOOL)shouldShowDutchPrayers {
    if (_showDutchPrayers == shouldShowDutchPrayers)
        return;
    
    _showDutchPrayers = shouldShowDutchPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showDutchPrayers forKey:kLanguageDutch];
    [userDefaults synchronize];
    
    if (_showDutchPrayers)
        [self.languages addObject:kLanguageDutch];
    else
        [self.languages removeObject:kLanguageDutch];
    
    if ([self.languages count] == 0)
        self.showEnglishPrayers = YES;
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showEnglishPrayers = _showEnglishPrayers;
- (void)setShowEnglishPrayers:(BOOL)shouldShowEnglishPrayers {
    if (_showEnglishPrayers == shouldShowEnglishPrayers)
        return;
    
    _showEnglishPrayers = shouldShowEnglishPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showEnglishPrayers forKey:kLanguageEnglish];
    [userDefaults synchronize];
    
    if (_showEnglishPrayers)
        [self.languages addObject:kLanguageEnglish];
    else
        [self.languages removeObject:kLanguageEnglish];
    
    if ([self.languages count] == 0)
        self.showEnglishPrayers = YES;
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showFrenchPrayers = _showFrenchPrayers;
- (void)setShowFrenchPrayers:(BOOL)shouldShowFrenchPrayers {
    if (_showFrenchPrayers == shouldShowFrenchPrayers)
        return;
    
    _showFrenchPrayers = shouldShowFrenchPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showFrenchPrayers forKey:kLanguageFrench];
    [userDefaults synchronize];
    
    if (_showFrenchPrayers)
        [self.languages addObject:kLanguageFrench];
    else
        [self.languages removeObject:kLanguageFrench];
    
    if ([self.languages count] == 0)
        self.showEnglishPrayers = YES;
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showPersianPrayers = _showPersianPrayers;
- (void)setShowPersianPrayers:(BOOL)shouldShowPersianPrayers {
    if (_showPersianPrayers == shouldShowPersianPrayers)
        return;
    
    _showPersianPrayers = shouldShowPersianPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showPersianPrayers forKey:kLanguagePersian];
    [userDefaults synchronize];
    
    if (_showPersianPrayers)
        [self.languages addObject:kLanguagePersian];
    else
        [self.languages removeObject:kLanguagePersian];
    
    if ([self.languages count] == 0)
        self.showEnglishPrayers = YES;
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showSpanishPrayers = _showSpanishPrayers;
- (void)setShowSpanishPrayers:(BOOL)shouldShowSpanishPrayers {
    if (_showSpanishPrayers == shouldShowSpanishPrayers)
        return;
    
    _showSpanishPrayers = shouldShowSpanishPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showSpanishPrayers forKey:kLanguageSpanish];
    [userDefaults synchronize];
    
    if (_showSpanishPrayers)
        [self.languages addObject:kLanguageSpanish];
    else
        [self.languages removeObject:kLanguageSpanish];
    
    if ([self.languages count] == 0)
        self.showEnglishPrayers = YES;
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@synthesize showSlovakPrayers = _showSlovakPrayers;
- (void)setShowSlovakPrayers:(BOOL)shouldShowSlovakPrayers {
    if (_showSlovakPrayers == shouldShowSlovakPrayers) {
        return;
    }
    
    _showSlovakPrayers = shouldShowSlovakPrayers;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_showSlovakPrayers forKey:kLanguageSlovak];
    [userDefaults synchronize];
    
    if (_showSlovakPrayers) {
        [self.languages addObject:kLanguageSlovak];
    } else {
        [self.languages removeObject:kLanguageSlovak];
    }
    
    if ([self.languages count] == 0) {
        self.showEnglishPrayers = YES;
    }
    
    [self buildLanguages];
    [[NSNotificationCenter defaultCenter] postNotificationName:PBNotificationLanguagesPreferenceChanged
                                                        object:nil];
}

@end
