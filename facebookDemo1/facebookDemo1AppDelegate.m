//
//  facebookDemo1AppDelegate.m
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookDemo1AppDelegate.h"
#import "facebookDemo1ViewController.h"
#import "URLParser.h"
#import "EGOHTTPFormRequest.h"
#import "keys.h"
@implementation facebookDemo1AppDelegate
@synthesize facebook;
@synthesize navigationController;
@synthesize window;
@synthesize authenticationViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    //facebook  of the facebook class
    facebook = [[Facebook alloc] initWithAppId:@"149013028496185"];
    //[facebook authorize:nil delegate:self];
    NSArray *permissions = [[NSArray arrayWithObjects:@"email", @"read_stream", @"user_checkins", @"friends_checkins", @"publish_checkins", @"publish_stream", @"user_status", nil] retain];
    [facebook authorize:permissions delegate:self];
    self.authenticationViewController = [[[AuthenticationViewController alloc] initWithNibName:@"AuthenticationView" bundle:nil] autorelease];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [navigationController release];
    [super dealloc];
}

#pragma - Outbound Traffic
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *searchString = kGowallaRedirectURI;
    NSString *toSearchString = CFURLGetString((CFURLRef *)url);
    NSRange prefixRange = [toSearchString rangeOfString:searchString];
    if(prefixRange.length == 0){
        [facebook handleOpenURL:url];
    } else {
        NSLog(@"application:handleOpenURL: %@", url);
        URLParser * parser = [[[URLParser alloc] initWithURLString:[url absoluteString]] autorelease];
        NSString * code = [parser valueForVariable:@"code"];
        NSLog(@"API KEY = %@", kGowallaAPIKey);
        NSURL * OAuthTokenURL = [NSURL URLWithString:@"https://gowalla.com/api/oauth/token"];
        EGOHTTPFormRequest * request = [[[EGOHTTPFormRequest alloc] initWithURL:OAuthTokenURL delegate:self] autorelease];
        [request setPostValue:@"authorization_code" 
                       forKey:@"grant_type"];
        [request setPostValue:kGowallaAPIKey
                       forKey:@"client_id"];
        [request setPostValue:kGowallaAPISecret
                       forKey:@"client_secret"];
        [request setPostValue:code 
                       forKey:@"code"];
        [request setPostValue:kGowallaRedirectURI
                       forKey:@"redirect_uri"];
        
        [request setDidFinishSelector:@selector(applicationDidAuthorizeWithRequest:)];
        [request startSynchronous];
    }
    return YES;
}

- (void)applicationDidAuthorizeWithRequest:(EGOHTTPFormRequest *)request {
	NSLog(@"applicationDidAuthorizeWithRequest: %@", request.responseString);
	NSDictionary * response = [NSDictionary dictionaryWithJSONData:[request responseData] error:nil];
	
	[[NSUserDefaults standardUserDefaults] setObject:[response valueForKey:@"access_token"] 
											  forKey:kGowallaBasicOAuthAccessTokenPreferenceKey];
	[[NSUserDefaults standardUserDefaults] setObject:[response valueForKey:@"refresh_token"] 
											  forKey:kGowallaBasicOAuthRefreshTokenPreferenceKey];
	
	NSDate * expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[response valueForKey:@"expires_in"] doubleValue]];
	[[NSUserDefaults standardUserDefaults] setObject:expirationDate 
											  forKey:kGowallaBasicOAuthTokenExpirationPreferenceKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Refresh access token if it is expired
	if ([expirationDate compare:[NSDate date]] == NSOrderedAscending) {
		NSURL * OAuthTokenURL = [NSURL URLWithString:@"https://api.gowalla.com/api/oauth/token"];
		EGOHTTPFormRequest * request = [[[EGOHTTPFormRequest alloc] initWithURL:OAuthTokenURL delegate:self] autorelease];
		[request setPostValue:@"refresh_token" 
					   forKey:@"grant_type"];
		[request setPostValue:kGowallaAPIKey
					   forKey:@"client_id"];
		[request setPostValue:kGowallaAPISecret
					   forKey:@"client_secret"];
		[request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:kGowallaBasicOAuthRefreshTokenPreferenceKey]
					   forKey:@"refresh_token"];
		[request setPostValue:kGowallaRedirectURI
					   forKey:@"redirect_uri"];
		
		[request setDidFinishSelector:@selector(applicationDidAuthorizeWithRequest:)];
		[request startSynchronous];
	} else {
		[authenticationViewController dismissModalViewControllerAnimated:YES];
	}	
}

@end
