//
//  PrayerDatabase.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/25/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerDatabase.h"


NSString *const kBookmarksPrefKey = @"BookmarksPrefKey";
NSString *const kRecentsPrefKey = @"RecentsPrefKey";

NSString *const kBookmarkKeyCategory = @"BookmarkKeyCategory";
NSString *const kBookmarkKeyTitle = @"BookmarkKeyTitle";

NSString *const kRecentsKeyCategory = @"RecentsKeyCategory";
NSString *const kRecentsKeyTitle = @"RecentsKeyTitle";
NSString *const kRecentsKeyAccessTime = @"RecentsKeyAccessTime";

@implementation PrayerDatabase

- (id)init
{
	self = [super init];
	if (self)
	{
		categoriesDict = [[NSMutableDictionary alloc] init];
		
		// get the path to the prayers database
		NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"pbdb" ofType:@"db"];
		int rc = sqlite3_open([dbPath UTF8String], &dbHandle);
		if (rc != SQLITE_OK)
		{
			NSLog(@"Can't open the database: %s", sqlite3_errmsg(dbHandle));
		}
	}
	
	return self;
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

- (void)addPrayer:(Prayer*)prayer {
	NSMutableArray *prayers = [categoriesDict objectForKey:[prayer category]];
	if (prayers == nil)
	{
		prayers = [[NSMutableArray alloc] init];
		[categoriesDict setValue:prayers forKey:[prayer category]];
		[prayers release];
	}
	[prayers addObject:prayer];
}

- (NSArray*)getCategories {
	NSMutableArray *categories = [[NSMutableArray alloc] init];
	NSString *getCategoriesSQL = @"SELECT DISTINCT category FROM prayers";
	sqlite3_stmt *getCategoriesStmt;
	
	int rc = sqlite3_prepare_v2(dbHandle,
								[getCategoriesSQL UTF8String],
								[getCategoriesSQL lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
								getCategoriesStmt,
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
	
	//NSArray *categories = [categoriesDict allKeys];
//	NSArray *sortedCategories = [categories sortedArrayUsingSelector:@selector(compareCategories:)];
//	
//	return sortedCategories;
}

- (NSArray*)getPrayersForCategory:(NSString*)category {
	if (category == nil)
		return nil;
	
	NSArray* prayers = [categoriesDict objectForKey:category];
	prayers = [prayers sortedArrayUsingSelector:@selector(compare:)];
	
	return prayers;
}

- (int)numberOfPrayersForCategory:(NSString*)category {
	if (category == nil)
		return -1;
	
	NSArray *prayers = [categoriesDict objectForKey:category];
	if (prayers == nil)
		return -1;
	else
		return [prayers count];
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

- (BOOL)hasBookmarkForPrayer:(Prayer*)prayer {
	if (prayer == nil)
	{
		printf("[PrayerDatabase hasBookmarkForPrayer] received a nil prayer arg\n");
		return NO;
	}
	
	//NSDictionary *bookmark = [NSDictionary dictionaryWithObject:[prayer title] forKey:[prayer category]];
	NSMutableDictionary *bookmark = [[NSMutableDictionary alloc] initWithCapacity:2];
	[bookmark setObject:[prayer title] forKey:kBookmarkKeyTitle];
	[bookmark setObject:[prayer category] forKey:kBookmarkKeyCategory];
	
	return [bookmarkedPrayers containsObject:bookmark];
}

- (void)addBookmark:(Prayer*)prayer {
	if (prayer == nil)
	{
		printf("addBookmark: called with a nil prayer\n");
		return;
	}
	
	if (bookmarkedPrayers == nil)
	{
		// load up the bookmarks from disk
		[self getBookmarks];
	}
	
	NSMutableDictionary *bookmark = [[NSMutableDictionary alloc] initWithCapacity:2];
	[bookmark setObject:[prayer title] forKey:kBookmarkKeyTitle];
	[bookmark setObject:[prayer category] forKey:kBookmarkKeyCategory];
	[bookmarkedPrayers addObject:bookmark];
	
	CFPreferencesSetAppValue((CFStringRef)kBookmarksPrefKey, bookmarkedPrayers, kCFPreferencesCurrentApplication);
}

- (void)removeBookmark:(NSDictionary*)bookmark {
	
	[bookmarkedPrayers removeObject:bookmark];
	
	CFPreferencesSetAppValue((CFStringRef)kBookmarksPrefKey, bookmarkedPrayers, kCFPreferencesCurrentApplication);
}

- (void)clearRecents {
	[recentPrayers release];
	recentPrayers = [[NSMutableArray alloc] init];
	
	CFPreferencesSetAppValue((CFStringRef)kRecentsPrefKey, nil, kCFPreferencesCurrentApplication);
}

/*
 Returns an array of NSDictionary's mapping prayer category to title.
 The first index is the most recently accessed prayer.
*/
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

/*
 When the user views a prayer, this should be called,
 so the recents menu can be updated.
 */
- (void)accessedPrayer:(Prayer*)prayer {
	if (prayer == nil)
	{
		printf("accessedPrayer was given a nil\n");
		return;
	}
	
	if (recentPrayers == nil)
	{
		// load from the disk
		[self getRecent];
	}
	
	//NSDictionary *entry = [NSDictionary dictionaryWithObject:[prayer title] forKey:[prayer category]];
	NSMutableDictionary *entry = [[NSMutableDictionary alloc] initWithCapacity:3];
	[entry setObject:[prayer title] forKey:kRecentsKeyTitle];
	[entry setObject:[prayer category] forKey:kRecentsKeyCategory];
	[recentPrayers removeObject:entry];
	[recentPrayers insertObject:entry atIndex:0];

	CFPreferencesSetAppValue((CFStringRef)kRecentsPrefKey, recentPrayers, kCFPreferencesCurrentApplication);
}

- (Prayer*)prayerWithCategory:(NSString*)category title:(NSString*)title {
	
	NSArray *categoryPrayers = [categoriesDict objectForKey:category];
	if (categoryPrayers != nil)
	{
		for (int i=0; i<[categoryPrayers count]; i++)
		{
			if ([[[categoryPrayers objectAtIndex:i] title] isEqual:title])
				return [categoryPrayers objectAtIndex:i];
		}
	}
	
	return nil;
}

- (Prayer*)prayerWithBookmark:(NSDictionary*)bookmark {
	if (bookmark == nil)
		return nil;
	
	return [self prayerWithCategory:[bookmark objectForKey:kBookmarkKeyCategory] title:[bookmark objectForKey:kBookmarkKeyTitle]];
}

- (Prayer*)prayerWithRecentsEntry:(NSDictionary*)entry {
	if (entry == nil)
		return nil;
	
	return [self prayerWithCategory:[entry objectForKey:kRecentsKeyCategory] title:[entry objectForKey:kRecentsKeyTitle]];
}

#pragma mark ParserDelegate

// parsing started
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//printf("parserDidStartDocument\n");
}

// parsing ended
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//printf("parserDidEndDocument\n");
}

// parser error
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	printf("parseErrorOccurred: %s\n", [[parseError description] UTF8String]);
}

// parser element start
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	//printf("startElement: %s\n", [[elementName description] UTF8String]);
	if ([elementName isEqual:@"prayer"])
	{
		currPrayer = [[Prayer alloc] init];
		[currPrayer setAuthor:[attributeDict objectForKey:@"author"]];
		[currPrayer setCategory:[attributeDict objectForKey:@"category"]];
		[currPrayer setCitation:[attributeDict objectForKey:@"citation"]];
		[currPrayer setTitle:[attributeDict objectForKey:@"title"]];
		[currPrayer setWordCount:[attributeDict objectForKey:@"wordCount"]];
		[self addPrayer:currPrayer];
		currElementText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqual:@"prayer"])
	{
		[currPrayer setPrayerText:currElementText];
		[currElementText release];
		currElementText = nil;
		[currPrayer release];
		currPrayer = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//printf("found characters %s\n", [string UTF8String]);
	[currElementText appendString:string];
}

@end
