//
//  User.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

static NSString * const AFCurrentUserUpdateNotification = @"AFCurrentUserUpdate";
static NSString * const AFCurrentUserUpdateFailureNotification = @"AFCurrentUserUpdateFailure";

#import "AFObject.h"


@class Spot;
@class CheckIn;

@interface User : AFObject <NSCoding> {
	NSString * firstName;
	NSString * lastName;
	NSString * hometown;
	NSURL * imageURL;
	
	NSArray * checkIns;
	NSSet * currentCheckedIntoSpots;
	NSSet * visitedSpots;
}

@property (readonly) NSString * name;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSURL * imageURL;

@property (nonatomic, retain) NSArray * checkIns;
@property (nonatomic, retain) NSSet * currentCheckedIntoSpots;
@property (nonatomic, retain) NSSet * visitedSpots;

+ (User *)currentUser;
- (CheckIn *)checkInAtSpot:(Spot *)spot;
- (BOOL)isCurrentlyCheckedIntoSpot:(Spot *)spot;
- (BOOL)hasVisitedSpot:(Spot *)spot;

@end
