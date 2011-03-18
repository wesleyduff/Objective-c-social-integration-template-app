//
//  PassportViewController.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/07/01.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "PassportViewController.h"
#import "SpotViewController.h"

#import "User.h"
#import "CheckIn.h"
#import "Spot.h"

#import "EGOHTTPRequest.h"

#import "AFImageLoadingCell.h"
#import "EGOImageView.h"

#import "GowallaAPI.h"

@interface PassportViewController ()
- (void)updateContent;
@end

static NSDateFormatter * _dateFormatter;

static EGOHTTPRequest * _userRequest;
static EGOHTTPRequest * _userCheckInsRequest;

@implementation PassportViewController

@synthesize user;
@synthesize checkIns;

- (id)initWithGowallaUser:(User *)someUser {
	if (self = [super initWithNibName:@"PassportView" bundle:nil]) {
		self.user = someUser;
	}
	
	return self;
}

- (void)dealloc {
	[user release];
	[checkIns release];
	[super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.user.name;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView] autorelease];
	
	self.tableView.rowHeight = 60.0f;
	
	[self updateContent];
	
	_userRequest = [GowallaAPI requestForPath:[self.user.url path]
								   parameters:nil 
									 delegate:self 
									 selector:@selector(userRequestDidFinish:)];
	
	_userCheckInsRequest = [GowallaAPI requestForPath:[[self.user.url path] stringByAppendingPathComponent:@"events"]
										   parameters:nil 
											 delegate:self 
											 selector:@selector(checkInsRequestDidFinish:)];
	
	[_userRequest startAsynchronous];
	[_userCheckInsRequest startAsynchronous];
	[loadingActivityIndicatorView startAnimating];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	nameLabel = nil;
	hometownLabel = nil;
	imageView.delegate = nil;
	[imageView cancelImageLoad];
	imageView = nil;
	loadingActivityIndicatorView = nil;
	[_userRequest cancel];
	[_userCheckInsRequest cancel];
	[EGOHTTPRequest cancelRequestsForDelegate:self];
}

- (void)updateContent {
	nameLabel.text = self.user.name;
	hometownLabel.text = [self.user.hometown description];
	[imageView setImageURL:self.user.imageURL];
}

#pragma mark -
#pragma mark EGOHTTPRequest

- (void)userRequestDidFinish:(EGOHTTPRequest *)request {	
	NSLog(@"requestDidFinish: %@", request.responseHeaders);
	NSDictionary * response = [NSDictionary dictionaryWithJSONData:request.responseData 
															 error:nil];
	
	if (request.responseStatusCode == 200) {
		self.user = [[User alloc] initWithDictionary:response];
		self.checkIns = self.user.checkIns;
		[self updateContent];
		[self.tableView reloadData];
	} else {
		NSLog(@"requestDidFail: %@", request.error);
	}
	
	[loadingActivityIndicatorView stopAnimating];
}

- (void)checkInsRequestDidFinish:(EGOHTTPRequest *)request {	
	NSLog(@"requestDidFinish: %@", request.responseHeaders);
	NSDictionary * response = [NSDictionary dictionaryWithJSONData:request.responseData 
															 error:nil];
	
	if (request.responseStatusCode == 200) {
		NSMutableSet * mutableCheckins = [NSMutableSet setWithArray:self.checkIns];
		for (NSDictionary * dictionary in [response valueForKey:@"activity"]) {
			CheckIn * checkIn = [[CheckIn alloc] initWithDictionary:dictionary];
			[mutableCheckins addObject:checkIn];
			[checkIn release];
		}
		
		NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"timestamp" 
																		 ascending:NO] autorelease];
		
		self.checkIns = [[mutableCheckins allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[self.tableView reloadData];
	} else {
		NSLog(@"requestDidFail: %@", request.error);
	}
	
	[loadingActivityIndicatorView stopAnimating];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.checkIns count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.checkIns count] > 0) {
		return NSLocalizedString(@"Recent Check-Ins", nil);
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"Cell";
    
    AFImageLoadingCell * cell = (AFImageLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AFImageLoadingCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
										  reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (_dateFormatter == nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDoesRelativeDateFormatting:YES];
		[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[_dateFormatter setLocale:[NSLocale currentLocale]];
	}
	
	CheckIn * checkIn = [self.checkIns objectAtIndex:indexPath.row];
	
	[cell setImageURL:checkIn.spot.imageURL];
	cell.textLabel.text = checkIn.spot.name;
	cell.detailTextLabel.text = [_dateFormatter stringFromDate:checkIn.timestamp];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CheckIn * checkIn = [self.checkIns objectAtIndex:indexPath.row];
	SpotViewController * viewController = [[[SpotViewController alloc] initWithSpot:checkIn.spot] autorelease];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
