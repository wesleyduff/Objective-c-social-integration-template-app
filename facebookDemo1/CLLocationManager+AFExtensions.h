//
//  CLLocationManager+AFExtensions.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
	GPSAccuracyZeroBars,
	GPSAccuracyOneBar,
	GPSAccuracyTwoBars,
	GPSAccuracyThreeBars,
} GPSAccuracyLevel;

@interface CLLocationManager (AFExtensions)

- (BOOL)withinRadius:(CLLocationDistance)radius ofLocation:(CLLocation *)someLocation;
- (NSString *)directionToLocation:(CLLocation *)someLocation;
- (NSString *)distanceToLocation:(CLLocation *)someLocation;
- (NSString *)distanceAndDirectionTo:(CLLocation *)someLocation;

@end
