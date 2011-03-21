//
//  AuthenticationTwitterViewController.m
//  facebookDemo1
//
//  Created by Wes Duff on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationTwitterViewController.h"


@implementation AuthenticationTwitterViewController
@synthesize doneButton;
@synthesize webView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [doneButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIWebView Delegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; 
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];  
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webView:shouldStartLoadWithRequest:");
    NSLog(@"%@", [request.URL absoluteString]);
    
    return YES;
}

- (IBAction)DoneButtonAction:(id)sender {
    NSLog(@"doneButtonAction");
    
    NSString *script;
    script = @"(function() { return document.getElementById(\"oauth_pin\").firstChild.textContent; } ())";
    
    NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    if ([pin length] > 0) {
        NSLog(@"pin %@", pin);
        
        if ([delegate respondsToSelector:@selector(successfulAuthorizationWithPin:)])
            [delegate successfulAuthorizationWithPin:pin];
        
    }
    else {
        NSLog(@"no pin");
        if ([delegate respondsToSelector:@selector(failedAuthorization)])
            [delegate failedAuthorization];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
