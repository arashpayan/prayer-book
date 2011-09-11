//
//  QiblihFinder.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "QiblihFinder.h"

#define PI 3.141592653589793
#define TORAD(x)	((x) * PI / 180.0)
#define TODEG(x)	((x) * 180.0 / PI)

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
	
	double dLon = TORAD(qiblihCoordinate.longitude-userPos.longitude);
	double lat1 = TORAD(userPos.latitude);
	double lat2 = TORAD(qiblihCoordinate.latitude);
	double y = sin(dLon) * cos(lat2);
	double x = cos(lat1) * sin(lat2) -
				sin(lat1) * cos(lat2) * cos(dLon);
	bearing = TODEG(atan2(y, x));
	
	hasLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"location manager failed %@", error);
	hasLocation = NO;
	if (qiblihWatcher != nil)
		[qiblihWatcher qiblihBearingUpdated:-1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	NSLog(@"didUpdateHeading: %f", newHeading.trueHeading);
	if (!applicationActive)
		return;
	
	double relativeBearing = bearing - newHeading.trueHeading*PI/180.0;
	if (qiblihWatcher != nil && hasLocation)
		[qiblihWatcher qiblihBearingUpdated:relativeBearing];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return NO;
}


@end
