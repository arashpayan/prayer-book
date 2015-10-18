//
// Created by Arash Payan on 6/28/15.
// Copyright (c) 2015 Arash Payan. All rights reserved.
//

#import "PBLanguage.h"

@interface PBLanguage ()

@property (nonatomic, readwrite) NSString *code;
@property (nonatomic, readwrite) NSString *humanName;
@property (nonatomic, readwrite) BOOL rightToLeft;

@end

@implementation PBLanguage

- (id)copyWithZone:(NSZone *)zone {
    PBLanguage *l = [PBLanguage new];
    if (l) {
        l.code = self.code;
        l.humanName = self.humanName;
        l.rightToLeft = self.rightToLeft;
    }

    return l;
}

+ (PBLanguage *)languageWithCode:(NSString*)code humanName:(NSString*)humanName rtl:(BOOL)rtl {
    PBLanguage *l = [PBLanguage new];
    l.code = code;
    l.humanName = humanName;
    l.rightToLeft = rtl;

    return l;
}

+ (NSArray *)all {
    return @[
            PBLanguage.czech,
            PBLanguage.english,
            PBLanguage.spanish,
            PBLanguage.french,
            PBLanguage.icelandic,
            PBLanguage.dutch,
            PBLanguage.slovak,
            PBLanguage.fijian,
            PBLanguage.persian
    ];
}

+ (PBLanguage *)czech {
    return [PBLanguage languageWithCode:@"cs" humanName:@"Čeština" rtl:NO];
}

+ (PBLanguage *)english {
    return [PBLanguage languageWithCode:@"en" humanName:@"English" rtl:NO];
}

+ (PBLanguage *)spanish {
    return [PBLanguage languageWithCode:@"es" humanName:@"Español" rtl:NO];
}

+ (PBLanguage *)persian {
    return [PBLanguage languageWithCode:@"fa" humanName:@"فارسی" rtl:YES];
}

+ (PBLanguage *)fijian {
    return [PBLanguage languageWithCode:@"fj" humanName:@"Vakaviti" rtl:NO];
}

+ (PBLanguage *)french {
    return [PBLanguage languageWithCode:@"fr" humanName:@"Français" rtl:NO];
}

+ (PBLanguage *)dutch {
    return [PBLanguage languageWithCode:@"nl" humanName:@"Nederlands" rtl:NO];
}

+ (PBLanguage *)slovak {
    return [PBLanguage languageWithCode:@"sk" humanName:@"Slovenčina" rtl:NO];
}

+ (PBLanguage *)icelandic {
    return [PBLanguage languageWithCode:@"is" humanName:@"íslenska" rtl:NO];
}

+ (PBLanguage *)languageFromCode:(NSString *)code {
    for (PBLanguage *l in PBLanguage.all) {
        if ([l.code isEqualToString:code]) {
            return l;
        }
    }
    
    return nil;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    return [self isEqualToLanguage:other];
}

- (BOOL)isEqualToLanguage:(PBLanguage *)language {
    if (self == language) {
        return YES;
    }
    if (language == nil) {
        return NO;
    }
    if (self.code != language.code && ![self.code isEqualToString:language.code]) {
        return NO;
    }
    if (self.humanName != language.humanName && ![self.humanName isEqualToString:language.humanName]) {
        return NO;
    }
    if (self.rightToLeft != language.rightToLeft) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.code hash];
    hash = hash * 31u + [self.humanName hash];
    hash = hash * 31u + self.rightToLeft;
    return hash;
}

- (NSString*)description {
    return self.code;
}

@end