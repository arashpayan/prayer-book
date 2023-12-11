//
//  PBLocalization.m
//  baha
//
//  Created by Arash on 2/1/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* _Nonnull l10n(NSString * _Nonnull str) {
    return NSLocalizedString(str, NULL);
}
