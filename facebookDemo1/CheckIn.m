//
//  CheckIn.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "CheckIn.h"
#import "User.h"
#import "Spot.h"

#import "ISO8601DateFormatter.h"

static ISO8601DateFormatter * _ISO8601DateFormatter;

@implementation CheckIn

@synthesize user;
@synthesize spot;
@synthesize timestamp;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		self.user = [[User alloc] initWithDictionary:[dictionary valueForKey:@"user"]];
		self.spot = [[Spot alloc] initWithDictionary:[dictionary valueForKey:@"spot"]];
		
		if ([dictionary objectForKey:@"created_at"]) {
			if (_ISO8601DateFormatter == nil) {
				_ISO8601DateFormatter = [[ISO8601DateFormatter alloc] init];
			}
			
			self.timestamp = [_ISO8601DateFormatter dateFromString:[dictionary valueForKey:@"created_at"]];
		}
	}
	
	return self;
}

- (void)dealloc {
	[user release];
	[spot release];
	[timestamp release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	self.user = [coder decodeObjectForKey:@"user"];
	self.spot = [coder decodeObjectForKey:@"spot"];
	self.timestamp = [coder decodeObjectForKey:@"timestamp"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.user
				 forKey:@"user"];
	[coder encodeObject:self.spot
				 forKey:@"spot"];
	[coder encodeObject:self.timestamp
				 forKey:@"timestamp"];
}

@end
