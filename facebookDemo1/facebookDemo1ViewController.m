//
//  facebookDemo1ViewController.m
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookDemo1ViewController.h"
#import "keys.h"

@implementation facebookDemo1ViewController
@synthesize getUserInfoButton;
@synthesize dialogPopUpExampleButton;
@synthesize facebook;
@synthesize appDelegate;
- (void)dealloc
{
    [getUserInfoButton release];
    [dialogPopUpExampleButton release];
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
    [self setDialogPopUpExampleButton:nil];
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

- (IBAction)dialogPopUpExample:(id)sender {
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

@end
