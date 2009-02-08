//
//  Prayer.h
//  WI2
//
//  Created by Arash Payan on 8/12/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Prayer : NSObject {
	NSString *_category;
	NSString *_prayerText;
	NSString *_title;
	NSString *_citation;
	NSString *_author;
	NSString *_wordCount;
}

- (NSString*)description;
- (id)initWithCategory:(NSString*)category withText:(NSString*)text withOpeningWords:(NSString*)openingWords;
- (NSString*)category;
- (void)setCategory:(NSString*)category;
- (NSString*)prayerText;
- (void)setPrayerText:(NSString*)prayerText;
- (NSString*)title;
- (void)setTitle:(NSString*)title;
- (NSString*)citation;
- (void)setCitation:(NSString*)citation;
- (NSString*)author;
- (void)setAuthor:(NSString*)author;
- (NSString*)wordCount;
- (void)setWordCount:(NSString*)wordCount;

// for comparing prayer titles
- (NSComparisonResult)compare:(Prayer *)aPrayer;

@end
