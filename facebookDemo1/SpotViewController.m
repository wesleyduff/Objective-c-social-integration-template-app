//
//  SpotViewController.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "SpotViewController.h"
#import "CheckInSuccessViewController.h"
#import "PassportViewController.h"

#import "Spot.h"
#import "User.h"
#import "CheckIn.h"

#import "EGOHTTPRequest.h"
#import "EGOHTTPFormRequest.h"

#import "AFImageLoadingCell.h"

#import "CLLocationManager+AFExtensions.h"
#import "NSData+Base64.h"
#import "GowallaAPI.h"

@interface SpotViewController () 
- (void)updateContent;
- (void)handleCheckInButtonState;
@end

static NSDateFormatter * _dateFormatter;

static EGOHTTPRequest * _spotRequest;
static EGOHTTPFormRequest * _checkInRequest;

@implementation SpotViewController

@synthesize spot;
@synthesize checkIns;
@synthesize locationManager;

- (id)initWithSpot:(Spot *)someSpot {
	if (self = [super initWithNibName:@"SpotView" bundle:nil]) {
		self.spot = someSpot;
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		self.locationManager.distanceFilter = 80.0;
	}
	
	return self;
}

- (void)dealloc {
	self.locationManager.delegate = nil;
	[spot release];
	[locationManager release];
	[super dealloc];
}

- (void)handleCheckInButtonState {
	if ([[User currentUser] isCurrentlyCheckedIntoSpot:self.spot]) {
		[checkInButton setTitle:NSLocalizedString(@"Checked In", nil)
					   forState:UIControlStateDisabled];
		checkInButton.hidden = NO;
		checkInButton.enabled = NO;
	} else if ([Spot canCheckInAtSpot:self.spot fromLocation:self.locationManager.location]) {
		[checkInButton setTitle:NSLocalizedString(@"Check In", nil) 
					   forState:UIControlStateNormal];
		checkInButton.hidden = NO;
		checkInButton.enabled = YES;
	} else if (self.locationManager.location) {
		[checkInButton setTitle:[self.locationManager distanceAndDirectionTo:self.spot.location] 
					   forState:UIControlStateDisabled];
		checkInButton.hidden = NO;
		checkInButton.enabled = NO;
	} else {
		checkInButton.hidden = YES;
	}
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = self.spot.name;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView] autorelease];
	
	self.tableView.rowHeight = 60.0f;
	
	mapView.layer.cornerRadius = 8.0f;
	mapView.layer.borderWidth = 1.0f;
	mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	
	[self updateContent];
	
	_spotRequest = [[GowallaAPI requestForPath:[self.spot.url path] 
								   parameters:nil 
									 delegate:self 
									 selector:@selector(requestDidFinish:)] retain];
	
	[_spotRequest startAsynchronous];
	[loadingActivityIndicatorView startAnimating];	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.locationManager stopUpdatingLocation];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	nameLabel = nil;
	localityRegionLabel = nil;
	imageView.delegate = nil;
	[imageView cancelImageLoad];
	imageView = nil;
	checkInButton = nil;
	mapView = nil;
	loadingActivityIndicatorView = nil;
	[_spotRequest cancel];
	[_checkInRequest cancel];
	[EGOHTTPRequest cancelRequestsForDelegate:self];
	[self.locationManager stopUpdatingLocation];
}

- (void)updateContent {
	nameLabel.text = self.spot.name;
	localityRegionLabel.text = self.spot.localityRegionString;
	[imageView setImageURL:self.spot.imageURL];
	
	checkInButton.titleLabel.numberOfLines = 2;
	checkInButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	[checkInButton setTitle:NSLocalizedString(@"Check In", nil) 
				   forState:UIControlStateNormal];
	[checkInButton setTitle:NSLocalizedString(@"Checking In...", nil) 
				   forState:UIControlStateDisabled];
	
	[mapView addAnnotation:self.spot];
	[mapView setRegion:MKCoordinateRegionMakeWithDistance(self.spot.coordinate, 1000, 1000) animated:YES];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)checkIn:(id)sender {
	[checkInButton setTitle:NSLocalizedString(@"Checking In...", nil) 
				   forState:UIControlStateDisabled];
	[checkInButton setEnabled:NO];
	
	CLLocation * currentLocation = self.locationManager.location;
	
	NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
	[parameters setObject:self.spot.identifier 
				   forKey:@"spot_id"];
	[parameters setObject:[[NSNumber numberWithDouble:currentLocation.coordinate.latitude] stringValue] 
				   forKey:@"lat"];
	[parameters setObject:[[NSNumber numberWithDouble:currentLocation.coordinate.longitude] stringValue] 
				   forKey:@"lng"];
	[parameters setObject:[[NSNumber numberWithDouble:currentLocation.horizontalAccuracy] stringValue] 
				   forKey:@"accuracy"];
	
	_checkInRequest = [GowallaAPI formRequestForPath:@"checkins" 
										  parameters:parameters 
											delegate:self 
											selector:@selector(requestDidFinish:)];
	
	[loadingActivityIndicatorView startAnimating];
	[_checkInRequest startSynchronous];
}

#pragma mark -
#pragma mark EGOHTTPRequest

- (void)requestDidFinish:(EGOHTTPRequest *)request {	
	NSLog(@"requestDidFinish: %@", request.responseHeaders);
	NSDictionary * response = [NSDictionary dictionaryWithJSONData:request.responseData 
															 error:nil];
	
	if (request.responseStatusCode == 200) {
		if ([request isEqual:_spotRequest]) {
			self.spot = [[Spot alloc] initWithDictionary:response];
			self.checkIns = self.spot.checkIns;
			[self.tableView reloadData];			
		} else if ([request isEqual:_checkInRequest]) {
			[self handleCheckInButtonState];

			CheckIn * checkIn = [[User currentUser] checkInAtSpot:self.spot];
			self.spot.checkIns = [[NSArray arrayWithObject:checkIn] arrayByAddingObjectsFromArray:self.spot.checkIns];
			[self.tableView reloadData];
			
			NSString * html = [response valueForKey:@"detail_html"];
			CheckInSuccessViewController * viewController = [[[CheckInSuccessViewController alloc] initWithCheckIn:checkIn 
																										detailHTML:html] autorelease];
			UINavigationController * modalNavigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
			[self.navigationController presentModalViewController:modalNavigationController animated:YES];
		}
	} else {
		[[[[UIAlertView alloc] initWithTitle:[response valueForKey:@"title"]
									 message:[response valueForKey:@"message"]
									delegate:nil 
						   cancelButtonTitle:NSLocalizedString(@"OK", nil) 
						   otherButtonTitles:nil] autorelease] show];
	}
	
	[loadingActivityIndicatorView stopAnimating];
	[self handleCheckInButtonState];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation 
{
	NSLog(@"locationManager:didUpdateToLocation:fromLocation:");
	[self handleCheckInButtonState];
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
	
	[cell setImageURL:checkIn.user.imageURL];
	cell.textLabel.text = checkIn.user.name;
	cell.detailTextLabel.text = [_dateFormatter stringFromDate:checkIn.timestamp];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CheckIn * checkIn = [self.checkIns objectAtIndex:indexPath.row];
	PassportViewController * viewController = [[[PassportViewController alloc] initWithGowallaUser:checkIn.user] autorelease];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
