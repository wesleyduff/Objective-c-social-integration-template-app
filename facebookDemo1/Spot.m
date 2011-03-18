//
//  Spot.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "Spot.h"
#import "CheckIn.h"

#define kCheckInRadiusAllowance 1000

@implementation Spot

@synthesize name;
@synthesize imageURL;
@synthesize locality;
@synthesize region;
@dynamic localityRegionString;
@synthesize radius;
@synthesize location;
@synthesize checkIns;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		self.name = [dictionary valueForKey:@"name"];
		self.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"image_url"]];
		self.locality = [dictionary valueForKeyPath:@"address.locality"];
		self.region = [dictionary valueForKeyPath:@"address.region"];
		
		self.location = [[CLLocation alloc] initWithLatitude:[[dictionary valueForKey:@"lat"] doubleValue]
												   longitude:[[dictionary valueForKey:@"lng"] doubleValue]];
		self.radius = [dictionary valueForKey:@"radius_meters"];
		
		NSMutableArray * recentCheckIns = [NSMutableArray array];
		for (NSDictionary * checkInDictionary in [dictionary valueForKey:@"last_checkins"]) {
			CheckIn * checkIn = [[CheckIn alloc] initWithDictionary:checkInDictionary];
			checkIn.spot = self;
			[recentCheckIns addObject:checkIn];
			[checkIn release];
		}
		
		self.checkIns = [NSArray arrayWithArray:recentCheckIns];
	}
	
	return self;
}

- (void)dealloc {
	[name release];
	[imageURL release];
	[radius release];
	[location release];
	[checkIns release];
	[super dealloc];
}

+ (BOOL)canCheckInAtSpot:(Spot *)spot fromLocation:(CLLocation *)someLocation {
	double r = kCheckInRadiusAllowance + [spot.radius doubleValue];
	return r >= [someLocation distanceFromLocation:spot.location];
}

- (NSString *)localityRegionString {
	if (self.locality && self.region) {
		return [NSString stringWithFormat:NSLocalizedString(@"%@, %@", @"#{locality}, #{region}"), self.locality, self.region];
	} else if (self.locality) {
		return self.locality;
	}
	
	return nil;
}

#pragma mark -
#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate {
	return self.location.coordinate;
}

- (NSString *)title {
	return self.name;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	self.name = [coder decodeObjectForKey:@"name"];
	self.imageURL = [coder decodeObjectForKey:@"imageURL"];
	self.radius = [coder decodeObjectForKey:@"radius"];
	self.location = [coder decodeObjectForKey:@"location"];
	self.checkIns = [coder decodeObjectForKey:@"checkIns"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.name
				 forKey:@"name"];
	[coder encodeObject:self.imageURL
				 forKey:@"imageURL"];
	[coder encodeObject:self.radius
				 forKey:@"radius"];
	[coder encodeObject:self.location
				 forKey:@"location"];
	[coder encodeObject:self.checkIns
				 forKey:@"checkIns"];
}

@end
