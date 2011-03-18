//
//  GowallaAPI.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/30.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "GowallaAPI.h"

static void setHTTPHeadersForRequest(EGOHTTPRequest * request) {
	// Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
	[request addRequestHeader:@"Accept" 
						value:@"application/json"];
	
	// Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
	NSString *preferredLanguageCodes = [[NSLocale preferredLanguages] componentsJoinedByString:@", "];
	[request addRequestHeader:@"Accept-Language" 
						value:[NSString stringWithFormat:@"%@, en-us;q=0.8", preferredLanguageCodes]];
	
	// Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
	[request addRequestHeader:@"Content-Type" 
						value:@"application/json"];	
	
	// X-Gowalla-API-Key HTTP Header; see http://api.gowalla.com/api/docs
	[request addRequestHeader:@"X-Gowalla-API-Key" 
						value:kGowallaAPIKey];
}

@implementation GowallaAPI

+ (EGOHTTPRequest *)requestForPath:(NSString *)path 
						parameters:(NSDictionary *)keyedParameters 
						  delegate:(id)delegate 
						  selector:(SEL)selector
{
	NSMutableDictionary * mutableKeyedParameters = [NSMutableDictionary dictionaryWithDictionary:keyedParameters];
	
	NSString * OAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGowallaBasicOAuthAccessTokenPreferenceKey];
	if (OAuthToken) {
		[mutableKeyedParameters setObject:OAuthToken 
								   forKey:@"oauth_token"];
	}
	
	NSMutableArray * parameters = [NSMutableArray array];
	for (id key in [mutableKeyedParameters allKeys]) {
		NSString * parameter = [NSString stringWithFormat:@"%@=%@", key, [mutableKeyedParameters valueForKey:key]];
		[parameters addObject:parameter];
	}
	
	NSURL * url = [NSURL URLWithString:[path stringByAppendingFormat:@"?%@", [parameters componentsJoinedByString:@"&"]]
						 relativeToURL:[NSURL URLWithString:kGowallaAPIBaseURL]];
		
	EGOHTTPRequest * request = [[EGOHTTPRequest alloc] initWithURL:url];
	[request setDelegate:delegate];
	[request setDidFinishSelector:selector];
	setHTTPHeadersForRequest(request);
	
	return request;
}

+ (EGOHTTPFormRequest *)formRequestForPath:(NSString *)path 
								parameters:(NSDictionary *)keyedParameters 
								  delegate:(id)delegate 
								  selector:(SEL)selector
{
	NSURL * url = [NSURL URLWithString:path
						 relativeToURL:[NSURL URLWithString:kGowallaAPIBaseURL]];
	EGOHTTPFormRequest * request = [[EGOHTTPFormRequest alloc] initWithURL:url];
	[request setDelegate:delegate];
	[request setDidFinishSelector:selector];
	setHTTPHeadersForRequest(request);
	
	NSMutableDictionary * mutableKeyedParameters = [NSMutableDictionary dictionaryWithDictionary:keyedParameters];
	
	NSString * OAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGowallaBasicOAuthAccessTokenPreferenceKey];
	if (OAuthToken) {
		[mutableKeyedParameters setObject:OAuthToken 
								   forKey:@"oauth_token"];
	}
	
	for (id key in [mutableKeyedParameters allKeys]) {
		[request setPostValue:[mutableKeyedParameters valueForKey:key] 
					   forKey:key];
	}

	
	return request;
}

@end
