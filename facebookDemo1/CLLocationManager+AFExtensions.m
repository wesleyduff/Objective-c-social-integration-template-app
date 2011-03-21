//
//  CLLocationManager+AFExtensions.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "CLLocationManager+AFExtensions.h"
#import "CLLocation+AFExtensions.h"

@implementation CLLocationManager (AFExtensions)

- (GPSAccuracyLevel)accuracyLevel {
	if (!self.location) {
		return GPSAccuracyZeroBars;
	}
	
	CLLocationAccuracy accuracy = self.location.horizontalAccuracy;
	if (accuracy > kCLLocationAccuracyKilometer ) {
		return GPSAccuracyOneBar;
	} else if (accuracy > kCLLocationAccuracyHundredMeters) {
		return GPSAccuracyTwoBars;
	} else {
		return GPSAccuracyThreeBars;
	}
}

- (BOOL)withinRadius:(CLLocationDistance)radius ofLocation:(CLLocation *)someLocation {
	return self.location && someLocation && radius > [self.location distanceFromLocation:someLocation];
}

- (NSString *)directionToLocation:(CLLocation *)someLocation {
	if(!self.location || !someLocation) {
		return NSLocalizedString(@"unknown distance", nil);
	}
	
	double bearing = [self.location bearingInDegreesTowardsLocation:someLocation];
	
	if(bearing > 337.5) {
		return NSLocalizedString(@"north", nil);
	} else if(bearing > 292.5) {
		return NSLocalizedString(@"northwest", nil);
	} else if(bearing > 247.5) {
		return NSLocalizedString(@"west", nil);
	} else if(bearing > 202.5) {
		return NSLocalizedString(@"southwest", nil);
	} else if(bearing > 157.5) {
		return NSLocalizedString(@"south", nil);
	} else if(bearing > 112.5) {
		return NSLocalizedString(@"southeast", nil);
	} else if(bearing > 67.5) {
		return NSLocalizedString(@"east", nil);
	} else if(bearing > 22.5) {
		return NSLocalizedString(@"northeast", nil);
	} else if(bearing > 0) {
		return NSLocalizedString(@"north", nil);
	} else {
		return NSLocalizedString(@"unknown direction", nil);
	}
}

- (NSString *)distanceToLocation:(CLLocation *)someLocation {
	if(!self.location || !someLocation) {
		return NSLocalizedString(@"unknown distance", nil);
	}
	
	float meters = [self.location distanceFromLocation:someLocation];
	if(meters > 1000.0) {
		float km = meters * 0.001;
		if(km > 5.0) {
			return [NSString stringWithFormat:NSLocalizedString(@"%0.0f km", nil), km];
		} else {
			return [NSString stringWithFormat:NSLocalizedString(@"%0.1f km", nil), km];
		}
	} else {
		return [NSString stringWithFormat:NSLocalizedString(@"%0.0f meters", nil), meters];
	}
}

- (NSString *)distanceAndDirectionTo:(CLLocation *)someLocation {
	if(!self.location || !someLocation) {
		return NSLocalizedString(@"unknown distance", nil);
	}
	
	return [NSString stringWithFormat:@"%@ %@", [self distanceToLocation:someLocation], [self directionToLocation:someLocation]];
}

@end
