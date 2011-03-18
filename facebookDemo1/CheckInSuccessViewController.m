//
//  CheckInSuccessViewController.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/30.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "CheckInSuccessViewController.h"

#import "CheckIn.h"


@implementation CheckInSuccessViewController

@synthesize checkIn;
@synthesize detailHTML;

- (id)initWithCheckIn:(CheckIn *)someCheckIn detailHTML:(NSString *)html {
	if (self = [super initWithNibName:@"CheckInSuccessView" bundle:nil]) {
		self.checkIn = someCheckIn;
		self.detailHTML = html;
	}
	
	return self;
}

- (void)dealloc {
	[checkIn release];
	[detailHTML release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																							target:nil 
																							action:@selector(dismissModalViewControllerAnimated:)] autorelease];

	[webView loadHTMLString:self.detailHTML baseURL:[NSURL URLWithString:kGowallaAPIBaseURL]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	webView.delegate = nil;
    webView = nil;
}

@end
