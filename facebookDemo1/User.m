//
//  User.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "User.h"
#import "CheckIn.h"
#import "Spot.h"

#import "GowallaAPI.h"


static User * _currentUser = nil;
static EGOHTTPRequest * _currentUserRequest = nil;
static EGOHTTPRequest * _currentUserRecentCheckInsRequest = nil;
static EGOHTTPRequest * _currentUserVisitedSpotsRequest = nil;

@implementation User

@dynamic name;
@synthesize firstName;
@synthesize lastName;
@synthesize hometown;
@synthesize imageURL;
@synthesize checkIns;
@synthesize currentCheckedIntoSpots;
@synthesize visitedSpots;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		self.firstName = [dictionary valueForKey:@"first_name"];
		self.lastName = [dictionary valueForKey:@"last_name"];
		self.hometown = [dictionary valueForKey:@"hometown"];
		self.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"image_url"]];
		
		NSMutableArray * someCheckIns = [NSMutableArray array];
		for (NSDictionary * checkInDictionary in [dictionary valueForKey:@"last_checkins"]) {
			CheckIn * checkIn = [[CheckIn alloc] initWithDictionary:checkInDictionary];
			checkIn.user = self;
			[someCheckIns addObject:checkIn];
			[checkIn release];
		}
		
		NSMutableSet * someCurrentSpots = [NSMutableSet set];
		for (NSDictionary * checkInDictionary in [dictionary valueForKey:@"current_checkins"]) {
			Spot * spot = [[Spot alloc] initWithDictionary:[checkInDictionary valueForKey:@"spot"]];
			[someCurrentSpots addObject:spot];
			[spot release];
		}

		self.checkIns = [NSArray arrayWithArray:someCheckIns];
		self.currentCheckedIntoSpots = [NSSet setWithSet:someCurrentSpots];
		self.visitedSpots = [NSSet setWithSet:self.currentCheckedIntoSpots];
	}
	
	return self;
}

- (void)dealloc {
	[firstName release];
	[lastName release];
	[hometown release];
	[imageURL release];
	[checkIns release];
	[super dealloc];
}

- (CheckIn *)checkInAtSpot:(Spot *)spot {
	CheckIn * checkIn = [[CheckIn alloc] init];
	checkIn.user = self;
	checkIn.spot = spot;
	checkIn.timestamp = [NSDate date];
	
	self.checkIns = [[NSArray arrayWithObject:checkIn] arrayByAddingObjectsFromArray:self.checkIns];
	self.visitedSpots = [self.visitedSpots setByAddingObject:checkIn.spot];
	self.currentCheckedIntoSpots = [self.currentCheckedIntoSpots setByAddingObject:checkIn.spot];
	
	return checkIn;
}

- (BOOL)isCurrentlyCheckedIntoSpot:(Spot *)spot {
	return [self.currentCheckedIntoSpots containsObject:spot];
}

- (BOOL)hasVisitedSpot:(Spot *)spot {
	return [self.visitedSpots containsObject:spot];
}

- (NSString *)name {
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

#pragma mark -
#pragma mark EGOHTTPRequest

+ (User *)currentUser {
	if (_currentUser == nil) {
		_currentUserRequest = [[GowallaAPI requestForPath:@"users/me" 
											   parameters:nil 
												 delegate:self 
												 selector:@selector(requestDidFinish:)] retain];
		[_currentUserRequest startSynchronous];
	}
	
	return _currentUser;
}

+ (void)requestDidFinish:(EGOHTTPRequest *)request {
	NSLog(@"requestDidFinish: %@", request);
	if (request.responseStatusCode == 200) {
		NSDictionary * response = [NSDictionary dictionaryWithJSONData:request.responseData 
																 error:nil];
		if ([request isEqual:_currentUserRequest]) {
			_currentUser = [[[User alloc] initWithDictionary:response] retain];
			[[NSNotificationCenter defaultCenter] postNotificationName:AFCurrentUserUpdateNotification object:self userInfo:nil];
			_currentUserRecentCheckInsRequest = [[GowallaAPI requestForPath:[response valueForKeyPath:@"activity_url"] 
														   parameters:nil 
															 delegate:self 
															 selector:@selector(requestDidFinish:)] retain];
			[_currentUserRecentCheckInsRequest startAsynchronous];
			
			_currentUserVisitedSpotsRequest = [[GowallaAPI requestForPath:[response valueForKey:@"_visited_spots_urls_url"] 
														   parameters:nil 
															 delegate:self 
															 selector:@selector(requestDidFinish:)] retain];
			[_currentUserVisitedSpotsRequest startAsynchronous];
		} else if ([request isEqual:_currentUserRecentCheckInsRequest]) {
			NSMutableSet * someCheckIns = [NSMutableSet setWithArray:_currentUser.checkIns];
			for (NSDictionary * dictionary in [response valueForKey:@"activity"]) {
				if ([[dictionary valueForKey:@"type"] isEqual:@"checkin"]) {
					CheckIn * checkIn = [[CheckIn alloc] initWithDictionary:dictionary];
					[someCheckIns addObject:checkIn];
					[checkIn release];
				}
			}
			_currentUser.checkIns = [[someCheckIns allObjects] sortedArrayUsingSelector:@selector(timestamp)];
		} else if ([request isEqual:_currentUserVisitedSpotsRequest]) {
			NSMutableSet * someSpots = [NSMutableSet set];
			for (NSString * relativeURLPath in [response valueForKey:@"urls"]) {
				Spot * spot = [[Spot alloc] init];
				spot.path = relativeURLPath;
				[someSpots addObject:spot];
				[spot release];
			}
			_currentUser.visitedSpots = [_currentUser.visitedSpots setByAddingObjectsFromSet:someSpots];
		}
	} else {
		NSLog(@"requestDidFail: %@", request.error);
		[[NSNotificationCenter defaultCenter] postNotificationName:AFCurrentUserUpdateFailureNotification object:self userInfo:nil];
	}
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	self.firstName = [coder decodeObjectForKey:@"firstName"];
	self.lastName = [coder decodeObjectForKey:@"lastName"];
	self.hometown = [coder decodeObjectForKey:@"hometown"];
	self.imageURL = [coder decodeObjectForKey:@"imageURL"];
	self.checkIns = [coder decodeObjectForKey:@"checkIns"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.firstName
				 forKey:@"firstName"];
	[coder encodeObject:self.lastName
				 forKey:@"lastName"];
	[coder encodeObject:self.hometown
				 forKey:@"hometown"];
	[coder encodeObject:self.imageURL
				 forKey:@"imageURL"];
	[coder encodeObject:self.checkIns
				 forKey:@"checkIns"];
}

@end
