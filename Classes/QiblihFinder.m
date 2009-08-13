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

@synthesize qiblihWatcher;

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
		
		if (locationManager.headingAvailable)
		{
			[locationManager startUpdatingLocation];
			[locationManager startUpdatingHeading];
		}
	}
	
	return self;
}

- (BOOL)isQiblihFinderEnabled {
	return locationManager.headingAvailable;
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
	
	if (delta.longitude > 0)
	{
		qiblihBearing = acos(delta.latitude/delta.longitude);
	}
	else if (delta.longitude < 0)
	{
		if (delta.latitude < 0)
		{
			qiblihBearing = atan(delta.longitude/delta.latitude) + PI;
		}
		else if (delta.latitude > 0)
		{
			qiblihBearing = atan(delta.longitude/delta.latitude) + 2.0*PI;
		}
		else	// latitude difference is 0
		{
			qiblihBearing = 1.5*PI;
		}
	}
	else	// longitude difference is 0
	{
		if (delta.latitude > 0)
			qiblihBearing = PI;
		else if (delta.latitude < 0)
			qiblihBearing = 0;
		else
			qiblihBearing == -1;	// they're standing directly on the qiblih
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"location manager failed %@", error);
	if (qiblihWatcher != nil)
		[qiblihWatcher qiblihBearingUpdated:-1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	double relativeBearing = qiblihBearing - newHeading.trueHeading*PI/180.0;
	if (qiblihWatcher != nil)
		[qiblihWatcher qiblihBearingUpdated:relativeBearing];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}


@end
