//
//  Prayer.h
//  WI2
//
//  Created by Arash Payan on 8/12/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Prayer : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *wordCount;
@property (nonatomic) long prayerId;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *citation;

- (NSString*)description;
- (id)initWithCategory:(NSString*)category withText:(NSString*)text withOpeningWords:(NSString*)openingWords;

// for comparing prayer titles
- (NSComparisonResult)compare:(Prayer *)aPrayer;

@end
