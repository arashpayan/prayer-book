//
//  Prayer.m
//  WI2
//
//  Created by Arash Payan on 8/12/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "Prayer.h"


@implementation Prayer

- (id)init {
	if (self = [super init]) {
		self.category = @"";
		self.text = @"";
		self.title = @"";
		self.citation = @"";
		self.author = @"";
		self.wordCount = @"0";
	}
	
	return self;
}

- (id)initWithCategory:(NSString*)aCategory withText:(NSString*)someText withOpeningWords:(NSString*)theOpeningWords {
	if (self = [self init]) {
		self.category = aCategory;
		self.text = someText;
		self.title = theOpeningWords;
	}
	
	return self;
}

- (NSString*)description {
	return self.title;
}

- (NSComparisonResult)compare:(Prayer *)aPrayer {
	return [self.title localizedCaseInsensitiveCompare:aPrayer.title];
}

@end
