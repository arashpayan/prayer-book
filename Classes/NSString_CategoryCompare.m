//
//  NSString_CategoryCompare.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/31/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "NSString_CategoryCompare.h"


@implementation NSString (CategoryCompare)

- (NSComparisonResult)compareCategories:(NSString*)aString {
	NSString *myString;
	if ([self hasPrefix:@"The "])
		myString = [self substringFromIndex:4];
	else
		myString = self;
	
	NSString *foreignString;
	if ([aString hasPrefix:@"The "])
		foreignString = [aString substringFromIndex:4];
	else
		foreignString = aString;
	
	return [myString localizedCaseInsensitiveCompare:foreignString];
}

@end
