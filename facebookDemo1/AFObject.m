//
//  AFObject.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "AFObject.h"

@implementation AFObject

@synthesize url;
@dynamic path;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.path = [dictionary valueForKey:@"url"];
	}
					
	return self;
}

- (void)dealloc {
	[url release];
	[super dealloc];
}

- (void)setPath:(NSString *)relativeURLPath {
	self.url = [NSURL URLWithString:relativeURLPath 
					  relativeToURL:[NSURL URLWithString:kGowallaAPIBaseURL]];
}

- (NSString *)path {
	return [self.url lastPathComponent];
}

- (NSString *)identifier {
	return self.path;
}

- (NSUInteger)hash {
	return [self.url hash];
}

- (BOOL)isEqual:(id)object {
	return [self isKindOfClass:[object class]] && [self hash] == [object hash];
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
	self.url = [coder decodeObjectForKey:@"url"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.url
				 forKey:@"url"];
}

@end
