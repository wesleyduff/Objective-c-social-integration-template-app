//
//  facebookDemo1ViewController.m
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookDemo1ViewController.h"
#import "URLParser.h"
#import "EGOHTTPFormRequest.h"
#import "keys.h"

@implementation facebookDemo1ViewController
@synthesize getUserInfoButton;
@synthesize displayDialogBoxButton;
@synthesize facebook;
@synthesize appDelegate;
@synthesize  authenticationViewController;
@synthesize consumer;
@synthesize accessToken;
- (void)dealloc
{
    [getUserInfoButton release];
    [displayDialogBoxButton release];
    [appDelegate release];
    [facebook release];
    [logIntoGowallaButton release];
    [authenticationViewController release];
    [logIntoTwitterButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.appDelegate = (facebookDemo1AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.authenticationViewController = self.appDelegate.authenticationViewController;
    
    if(self.consumer == nil){
        self.consumer = [[OAConsumer alloc] initWithKey:twitterConsumerkey secret:twitterConsumerSecret];
    }
    self.accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:twitterAppProviderName prefix:twitterAppPrefix];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setGetUserInfoButton:nil];
    [self setDisplayDialogBoxButton:nil];
    [logIntoGowallaButton release];
    logIntoGowallaButton = nil;
    [logIntoTwitterButton release];
    logIntoTwitterButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)getUserInfo:(id)sender {
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (IBAction)DisplayDialogBox:(id)sender {
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    //location of image
    
    /**
     Add this if you want to add an image to your dialog
     
     
    NSDictionary* media = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"image", @"type",
                           @"example.com/path/of/image", @"src",
                           @"example.com", @"href",
                           nil];
     
    */

    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Find it on Git Hub",@"text",@"https://github.com/slysop/Objective-c-social-integration-template-app",@"href",nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                NAMEFORDIALOG, @"name",
                                DIALOGCAPTION, @"caption",
                                DIALOGDESCRIPTION, @"description",
                                //[NSArray arrayWithObjects:media, nil ], @"media", /* Uncomment this if you are using an image */
                                @"https://github.com/slysop/Objective-c-social-integration-template-app", @"href", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   FacebookAppID, @"api_key",
                                   @"Your message to the user goes here", @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
    
    
    [self.appDelegate.facebook dialog:@"stream.publish"
            andParams:params
          andDelegate:self];
}
-(void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"Dialog Complete");
}

-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error {
    NSLog(@"failed dialog");
}

-(void)dialogCompleteWithUrl:(NSURL *)url
{
    NSLog(@"URL dialog done");
}

-(void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
     NSLog(@"URL dialog fail");
}

#pragma - facebook request delegate methods
-(void)request:(FBRequest *)request didLoad:(id)result {
    NSDictionary *resultsDict = [[NSDictionary alloc ] initWithDictionary:(NSDictionary *)result];
    NSLog(@"success");
}
-(void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
     NSLog(@"error no good");
}

- (IBAction)LogIntoGowalla:(id)sender {
    NSString * OAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGowallaBasicOAuthAccessTokenPreferenceKey];
	NSDate * OAuthTokenExpirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kGowallaBasicOAuthTokenExpirationPreferenceKey];
	if (OAuthToken == nil || [OAuthTokenExpirationDate compare:[NSDate date]] == NSOrderedAscending) {
		
		[self.navigationController presentModalViewController:self.appDelegate.authenticationViewController animated:YES];	
	}

}

#pragma -
#pragma Twitter Authentication Method Steps
- (IBAction)LogIntoTwitter:(id)sender {
    NSLog(@"authenticate Twitter");
    OAMutableURLRequest *request;
    OADataFetcher *fetcher;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    request = [[[OAMutableURLRequest alloc] initWithURL:url consumer:self.consumer token:self.accessToken realm:nil signatureProvider:nil] autorelease];
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oob"];
    NSArray *params = [NSArray arrayWithObject:p0];
    [request setParameters:params];
    
    fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    [p0 release];
    
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    if (ticket.didSucceed) {
        OAMutableURLRequest *request;
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (self.accessToken != nil) {
            [self.accessToken release];
            self.accessToken = nil;
        }
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
        
        request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                   consumer:self.consumer
                                                      token:self.accessToken
                                                      realm:nil
                                          signatureProvider:nil] autorelease];
        
        
        OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                    value:self.accessToken.key];
        NSArray *params = [NSArray arrayWithObject:p0];
        [request setParameters:params];
        //[request prepare];
        
        AuthenticationTwitterViewController *vc;
        vc = [[AuthenticationTwitterViewController alloc] initWithNibName:@"AuthenticationTwitterViewController" bundle:nil];
        vc.delegate = self;
        [self presentModalViewController:vc animated:YES];
        [vc.webView loadRequest:request];
        
        [vc release];
        [p0 release];
    }
    else {
        
    }
    
    
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(IBAction)TwitterAction:(id)sender {
    NSLog(@"in loggin to twitter");
   /* if(self.accessToken != nil){
        OAMutableURLRequest *request;
        OADataFetcher *fetcher;
        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
        request = [[[OAMutableURLRequest alloc] initWithURL:url consumer:self.consumer token:self.accessToken realm:nil signatureProvider:nil] autorelease];
        [request setHTTPMethod:@"POST"];
        
       OARequestParameter *x1 = [[OARequestParameter alloc] initWithName:@"status" value:self.message.text];
        
        NSArray *params = [NSArray arrayWithObjects:x1, nil];
        [request setParameters:params];
        
        
        fetcher = [[[OADataFetcher alloc] init] autorelease];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(statusRequestTokenTicket:didFinishWithData:)
                      didFailSelector:@selector(statusRequestTokenTicket:didFailWithError:)];
        
        [x1 release];
    }*/
    
}

#pragma mark -
#pragma mark AuthenticationTwitterViewControllerDelegate methods

- (void)successfulAuthorizationWithPin:(NSString *)pin {
    NSLog(@"successfulAuthorizationWithPin:%@", pin);
    OAMutableURLRequest *request;
    OADataFetcher *fetcher;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    request = [[[OAMutableURLRequest alloc] initWithURL:url
                                               consumer:self.consumer
                                                  token:self.accessToken
                                                  realm:nil
                                      signatureProvider:nil] autorelease];
    
    
    OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                value:self.accessToken.key];
    OARequestParameter *p1 = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                value:pin];
    NSArray *params = [NSArray arrayWithObjects:p0, p1, nil];
    [request setParameters:params];
    
    fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
    
    [p0 release];
    [p1 release];
    
    
    
    
}

- (void)failedAuthorization {
    NSLog(@"failedAuthorization");
}



- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"accessTokenSuccess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (self.accessToken != nil) {
            [self.accessToken release];
            self.accessToken = nil;
        }
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
        
        [self.accessToken storeInUserDefaultsWithServiceProviderName:twitterAppProviderName
                                                              prefix:twitterAppPrefix];
        
        
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseBody);
        [responseBody release];
    }    
    
    
}



- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
}



@end
