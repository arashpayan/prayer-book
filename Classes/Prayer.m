//
//  Prayer.m
//  WI2
//
//  Created by Arash Payan on 8/12/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "Prayer.h"


@implementation Prayer

- (id)init
{
	self = [super init];
	if (self)
	{
		_category = @"";
		_prayerText = @"";
		_title = @"";
		_citation = @"";
		_author = @"";
	}
	
	return self;
}

- (id)initWithCategory:(NSString*)category withText:(NSString*)text withOpeningWords:(NSString*)openingWords
{
	self = [super init];
	if (self)
	{
		_category = [category copy];
		_prayerText = [text copy];
		_title = [openingWords copy];
	}
	
	return self;
}

- (NSString*)category
{
	return [[_category copy] autorelease];
}

- (void)setCategory:(NSString*)category
{
	_category = [category copy];
}

- (NSString*)prayerText
{
	return [[_prayerText copy] autorelease];
}

- (void)setPrayerText:(NSString*)prayerText
{
	_prayerText = [prayerText copy];
}

- (NSString*)title
{
	return [[_title copy] autorelease];
}

- (void)setTitle:(NSString*)title
{
	_title = [title copy];
}

- (NSString*)citation
{
	return [[_citation copy] autorelease];
}

- (void)setCitation:(NSString*)citation
{
	_citation = [citation copy];
}

- (NSString*)author
{
	return [[_author copy] autorelease];
}

- (void)setAuthor:(NSString*)author
{
	_author = [author copy];
}

- (NSString*)description
{
	return [[_title copy] autorelease];
}
- (NSString*)wordCount
{
	return [[_wordCount copy] autorelease];
}

- (void)setWordCount:(NSString*)wordCount
{
	_wordCount = [wordCount copy];
}

- (NSComparisonResult)compare:(Prayer *)aPrayer {
	return [_title localizedCaseInsensitiveCompare:[aPrayer title]];
}

- (void)dealloc {
	[_title release];
	[_citation release];
	[_author release];
	[_category release];
	[_prayerText release];
	
	[super dealloc];
}

@end
