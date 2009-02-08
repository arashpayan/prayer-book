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
#import "NSString_CategoryCompare.h"

extern NSString *const kBookmarksPrefKey;
extern NSString *const kRecentsPrefKey;

extern NSString *const kBookmarkKeyCategory;
extern NSString *const kBookmarkKeyTitle;

extern NSString *const kRecentsKeyCategory;
extern NSString *const kRecentsKeyTitle;
extern NSString *const kRecentsKeyAccessTime;
	
@interface PrayerDatabase : NSObject {
	NSMutableString *currElementText;
	Prayer *currPrayer;
	sqlite3 *dbHandle;
	
	NSDictionary *categoriesDict;
	NSMutableArray *recentPrayers;
	NSMutableArray *bookmarkedPrayers;
}

+ (PrayerDatabase*)sharedInstance;
- (void)addPrayer:(Prayer*)prayer;
- (NSArray*)getCategories;
- (NSArray*)getPrayersForCategory:(NSString*)category;
- (int)numberOfPrayersForCategory:(NSString*)category;
- (void)addBookmark:(Prayer*)prayer;
- (BOOL)hasBookmarkForPrayer:(Prayer*)prayer;
- (NSArray*)getBookmarks;
- (void)clearRecents;
- (NSArray*)getRecent;
- (Prayer*)prayerWithCategory:(NSString*)category title:(NSString*)title;
- (Prayer*)prayerWithBookmark:(NSDictionary*)bookmark;
- (Prayer*)prayerWithRecentsEntry:(NSDictionary*)entry;
- (void)accessedPrayer:(Prayer*)prayer;
- (void)removeBookmark:(NSDictionary*)bookmark;

// NSXMLParser delegagte methods
- (void)parserDidStartDocument:(NSXMLParser *)parser;
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end
