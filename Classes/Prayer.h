//
//  Prayer.h
//  WI2
//
//  Created by Arash Payan on 8/12/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Prayer : NSObject {
	NSString *category;
	NSString *text;
	NSString *title;
	NSString *citation;
	NSString *author;
	NSString *wordCount;
	NSString *language;
	long prayerId;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *wordCount;
@property (nonatomic) long prayerId;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *citation;

- (NSString*)description;
- (id)initWithCategory:(NSString*)category withText:(NSString*)text withOpeningWords:(NSString*)openingWords;

// for comparing prayer titles
- (NSComparisonResult)compare:(Prayer *)aPrayer;

@end
