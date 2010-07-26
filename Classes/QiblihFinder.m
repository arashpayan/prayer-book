//
//  QiblihFinder.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "QiblihFinder.h"

#define PI 3.141592653589793

@implementation QiblihFinder

//@synthesize qiblihWatcher;
@synthesize applicationActive;

+ (QiblihFinder*)sharedInstance {
	static QiblihFinder *singleton;
	
	if (singleton == nil)
	{
		@synchronized(self)
		{
			if (singleton == nil)
				singleton = [[QiblihFinder alloc] init];
		}
	}
	
	return singleton;
}

- (id)init {
	if (self = [super init])
	{
		qiblihCoordinate.latitude = 32.94350962662634;
		qiblihCoordinate.longitude = 35.09188771247864;
		
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = 1;
		
		adjust = 0;
		bearing = 0;
	}
	
	return self;
}

- (BOOL)isQiblihFinderEnabled {
	return locationManager.headingAvailable;
}

- (id<QiblihWatcherDelegate>)qiblihWatcher {
	return qiblihWatcher;
}

- (void)setQiblihWatcher:(id<QiblihWatcherDelegate>)aWatcher {
	if (aWatcher != nil)
	{
		if (locationManager.headingAvailable)
		{
			[locationManager startUpdatingLocation];
			[locationManager startUpdatingHeading];
		}
	}
	else
	{
		if (locationManager.headingAvailable)
		{
			[locationManager stopUpdatingHeading];
			[locationManager stopUpdatingLocation];
		}
	}
	
	qiblihWatcher = aWatcher;
}

- (void)dealloc {
	[locationManager release];
	
    [super dealloc];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	CLLocationCoordinate2D userPos = newLocation.coordinate;
	CLLocationCoordinate2D delta;
	
	delta.latitude = qiblihCoordinate.latitude - userPos.latitude;
	delta.longitude = qiblihCoordinate.longitude - userPos.longitude;
	
	float DEG2RAD = PI/180.0;
	float x1 = userPos.longitude * DEG2RAD;
	float y1 = userPos.latitude * DEG2RAD;
	float x2 = qiblihCoordinate.longitude * DEG2RAD;
	float y2 = qiblihCoordinate.latitude * DEG2RAD;
	
	float a = cosf(y2) * sinf(x2 - x1);
	float b = cosf(y1) * sinf(y2) * cosf(y2) * cosf(x2 - x1);
	adjust = 0;
	
	bearing = 0;
	if ((a == 0) && (b == 0))
	{
		bearing = 0;
	}
	else if (b == 0) {
		if (a < 0)
			bearing = 3 * PI / 2.0;
		else
			bearing = PI / 2.0;
	}
	else if (b<0)
		adjust = PI;
	else {
		if (a < 0)
			adjust = 2 * PI;
		else
			adjust = 0;
	}
	bearing = (atanf(a/b) + adjust) * 180.0 / PI;
	
	//if (delta.longitude > 0)
//	{
//		qiblihBearing = acos(delta.latitude/delta.longitude);
//	}
//	else if (delta.longitude < 0)
//	{
//		if (delta.latitude < 0)
//		{
//			qiblihBearing = atan(delta.longitude/delta.latitude) + PI;
//		}
//		else if (delta.latitude > 0)
//		{
//			qiblihBearing = atan(delta.longitude/delta.latitude) + 2.0*PI;
//		}
//		else	// latitude difference is 0
//		{
//			qiblihBearing = 1.5*PI;
//		}
//	}
//	else	// longitude difference is 0
//	{
//		if (delta.latitude > 0)
//			qiblihBearing = PI;
//		else if (delta.latitude < 0)
//			qiblihBearing = 0;
//		else
//			qiblihBearing == -1;	// they're standing directly on the qiblih (unless you're inside the room and cleaning it, this shouldn't happen)
//	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"location manager failed %@", error);
	if (qiblihWatcher != nil)
		[qiblihWatcher qiblihBearingUpdated:-1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	if (!applicationActive)
		return;
	
	double relativeBearing = bearing - newHeading.trueHeading*PI/180.0;
	if (qiblihWatcher != nil)
		[qiblihWatcher qiblihBearingUpdated:relativeBearing];
	//double relativeBearing = qiblihBearing - newHeading.trueHeading*PI/180.0;
//	if (qiblihWatcher != nil)
//		[qiblihWatcher qiblihBearingUpdated:relativeBearing];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return NO;
}


@end
