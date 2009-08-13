//
//  QiblihFinder.h
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QiblihWatcherDelegate.h"

@interface QiblihFinder : NSObject <CLLocationManagerDelegate> {
	id<QiblihWatcherDelegate> qiblihWatcher;
	
	CLLocationCoordinate2D qiblihCoordinate;
	//CLLocationCoordinate2D delta;
	double qiblihBearing;
	
	CLLocationManager *locationManager;
}

@property (nonatomic, assign) id<QiblihWatcherDelegate>  qiblihWatcher;

+ (QiblihFinder*)sharedInstance;
- (BOOL)isQiblihFinderEnabled;

@end
