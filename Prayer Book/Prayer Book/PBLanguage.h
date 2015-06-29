//
// Created by Arash Payan on 6/28/15.
// Copyright (c) 2015 Arash Payan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PBLanguage : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *humanName;
@property (nonatomic, readonly) BOOL rightToLeft;

+ (NSArray *)all;
+ (PBLanguage *)czech;
+ (PBLanguage *)english;
+ (PBLanguage *)spanish;
+ (PBLanguage *)persian;
+ (PBLanguage *)fijian;
+ (PBLanguage *)french;
+ (PBLanguage *)dutch;
+ (PBLanguage *)slovak;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToLanguage:(PBLanguage *)language;

- (NSUInteger)hash;

@end