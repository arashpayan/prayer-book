//
//  PBTemplate.h
//  PBTemplate
//
//  Created by Arash on 3/22/23.
//

#import <Foundation/Foundation.h>

//! Project version number for PBTemplate.
FOUNDATION_EXPORT double PBTemplateVersionNumber;

//! Project version string for PBTemplate.
FOUNDATION_EXPORT const unsigned char PBTemplateVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PBTemplate/PublicHeader.h>


@interface PBTemplate : NSObject

+ (NSString*)renderTemplate:(NSString*)template data:(NSDictionary<NSString*, NSString*>*)data;

@end
