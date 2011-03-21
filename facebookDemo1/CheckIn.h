//
//  CheckIn.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "AFObject.h"

@class User;
@class Spot;

@interface CheckIn : AFObject <NSCoding> {
	User * user;
	Spot * spot;
	
	NSDate * timestamp;
}

@property (nonatomic, retain) User * user;
@property (nonatomic, retain) Spot * spot;

@property (nonatomic, retain) NSDate * timestamp;

@end
