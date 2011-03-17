//
//  facebookDemo1ViewController.m
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookDemo1ViewController.h"

@implementation facebookDemo1ViewController
@synthesize getUserInfoButton;
@synthesize getFriendsCheckinButton;
@synthesize facebook;
@synthesize appDelegate;
- (void)dealloc
{
    [getUserInfoButton release];
    [getFriendsCheckinButton release];
    [appDelegate release];
    [facebook release];
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
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setGetUserInfoButton:nil];
    [self setGetFriendsCheckinButton:nil];
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
    NSLog(@"access Token : %@", appDelegate.facebook.accessToken);
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (IBAction)getFriendsCheckins:(id)sender {
  NSLog(@"in getFrindsCheckins");
   // [facebook dialog:@"feed" andDelegate:self];
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    NSDictionary* media = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"image", @"type",
                           @"http://www.wesduff.com/facebook_apps/demo/graffitie.png", @"src",
                           @"http://www.wesduff.com/p/", @"href",
                           nil];

    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Check out my portfolio!",@"text",@"http://wesduff.com/p/",@"href",nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Graffitie App coming out this Fall!", @"name",
                                @"Graffitie Geo Tagging, by Wes Duff", @"caption",
                                @"it is fun to code all night. (c)All rights reserved", @"description",
                                [NSArray arrayWithObjects:media, nil ], @"media",
                                @"http://wesduff.com", @"href", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"149013028496185", @"api_key",
                                   @"Tag your graffitie on Facebook", @"user_message_prompt",
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
  //  NSLog(@"%@", [resultsDict objectForKey:@"3"]);
    NSLog(@"success");
}
-(void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
     NSLog(@"error no good");
}

@end
