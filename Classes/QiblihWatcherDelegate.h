//
//  QiblihWatcherDelegate.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/12/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol QiblihWatcherDelegate <NSObject>

- (void)qiblihBearingUpdated:(float)newBearing;

@end
