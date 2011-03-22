//
//  OAuthViewController.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/30.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "keys.h"
#import "URLParser.h"
#import "EGOHTTPFormRequest.h"
@implementation AuthenticationViewController


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString * OAuthURLString = [kGowallaOAuthURL stringByAppendingFormat:@"?redirect_uri=%@&client_id=%@&scope=%@", kGowallaRedirectURI, kGowallaAPIKey, @"read-write"];
	NSURL * OAuthURL = [NSURL URLWithString:OAuthURLString];
	NSURLRequest * OAuthURLRequest = [[[NSURLRequest alloc] initWithURL:OAuthURL] autorelease];
	
	[webView loadRequest:OAuthURLRequest];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[webView stopLoading];
	webView.delegate = nil;
	webView = nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)wv {
	NSLog(@"webViewDidStartLoad: %@", [wv.request URL]);
}
@end
