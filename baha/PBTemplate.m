//
//  PBTemplate.m
//  PBTemplate
//
//  Created by Arash on 3/22/23.
//

#import <Foundation/Foundation.h>
#import "PBTemplate.h"

@implementation PBTemplate

+ (NSString*)renderTemplate:(NSString*)template
                       data:(NSDictionary<NSString*, NSString*>*)data {
    NSString* rendering = template;
    for (NSString* key in data) {
        NSString* val = data[key];
        rendering = [rendering stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{{%@}}", key]
                                                         withString:val];
    }
    
    return rendering;
}

@end
