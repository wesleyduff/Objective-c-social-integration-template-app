//
//  SpotsViewController.m
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import "SpotsViewController.h"
#import "SpotViewController.h"

#import "Spot.h"
#import "User.h"

#import "GowallaAPI.h"

#import "AFSpotCell.h"

#import "CLLocationManager+AFExtensions.h"

static EGOHTTPRequest * _spotsRequest;
static EGOHTTPRequest * _spotsSearchRequest;

@interface SpotsViewController()
- (Spot *)tableView:(UITableView *)tableView spotForRowAtIndexPath:(NSIndexPath *)indexPath;
- (EGOHTTPRequest *)spotsRequestForLocation:(CLLocation *)location withParameters:(NSDictionary *)parameters;
@end


@implementation SpotsViewController

@synthesize spots;
@synthesize filteredSpots;
@synthesize locationManager;

#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.spots = [NSArray array];
		self.filteredSpots = [NSArray array];
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		self.locationManager.distanceFilter = 80.0;
	}
	
	return self;
}

- (void)dealloc {
	self.locationManager.delegate = nil;
	[spots release];
	[locationManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Spots", nil);
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:loadingActivityIndicatorView] autorelease];
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
	loadingActivityIndicatorView = nil;
	searchBar = nil;
	searchResultsLoadingTableHeaderView = nil;
	[_spotsRequest cancel];
	[_spotsSearchRequest cancel];
	[EGOHTTPRequest cancelRequestsForDelegate:self];
	[self.locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark EGOHTTPRequest

- (EGOHTTPRequest *)spotsRequestForLocation:(CLLocation *)location
							 withParameters:(NSDictionary *)someParameters 
{	
	NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:someParameters];
	[parameters setValue:[NSString stringWithFormat:@"%+.9f", location.coordinate.latitude] 
				  forKey:@"lat"];
	[parameters setValue:[NSString stringWithFormat:@"%+.9f", location.coordinate.longitude] 
				  forKey:@"lng"];
	
	return [GowallaAPI requestForPath:@"spots"
						   parameters:parameters 
							 delegate:self 
							 selector:@selector(requestDidFinish:)];
}

- (void)requestDidFinish:(EGOHTTPRequest *)request {
	NSLog(@"requestDidFinish: %@", request.responseHeaders);
	
	if (request.responseStatusCode == 200) {
		NSDictionary * response = [NSDictionary dictionaryWithJSONData:request.responseData 
																   error:nil];
		NSMutableSet * someSpots = [NSMutableSet set];
		for (NSDictionary * dictionary in [response valueForKey:@"spots"]) {
			Spot * spot = [[Spot alloc] initWithDictionary:dictionary];
			[someSpots addObject:spot];
			[spot release];
		}
		
		NSComparisonResult (^ distanceComparator)(id, id) = ^(id a, id b) {
			CLLocation * currentLocation = self.locationManager.location;
			CLLocationDistance distanceToA = [currentLocation distanceFromLocation:[a location]];
			CLLocationDistance distanceToB = [currentLocation distanceFromLocation:[b location]];
			if (distanceToA < distanceToB) {
				return NSOrderedAscending;
			} else if (distanceToA > distanceToB) {
				return NSOrderedDescending;
			} else {
				return NSOrderedSame;
			}
		};
		
		if ([request isEqual:_spotsSearchRequest]) {
			self.searchDisplayController.searchResultsTableView.tableHeaderView = nil;
			self.filteredSpots = [[someSpots allObjects] sortedArrayUsingComparator:distanceComparator];
			[self.searchDisplayController.searchResultsTableView reloadData];
		} else if ([request isEqual:_spotsRequest]) {
			self.spots = [[someSpots allObjects] sortedArrayUsingComparator:distanceComparator];
			[self.tableView reloadData];
		}
		
	} else {
		NSLog(@"requestDidFail: %@", request.error);
	}
	
	[loadingActivityIndicatorView stopAnimating];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation 
{
	NSLog(@"locationManager:didUpdateToLocation:fromLocation:");
	_spotsRequest = [self spotsRequestForLocation:newLocation 
								   withParameters:nil];
	[_spotsRequest startAsynchronous];
	[loadingActivityIndicatorView startAnimating];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (Spot *)tableView:(UITableView *)tableView spotForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredSpots objectAtIndex:indexPath.row];
    }
	else {
        return [self.spots objectAtIndex:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredSpots count];
    }
	
	return [self.spots count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"Cell";
    
    AFSpotCell * cell = (AFSpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AFSpotCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
								  reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Spot * spot = [self tableView:tableView spotForRowAtIndexPath:indexPath];

	[cell setImageURL:spot.imageURL];
	cell.textLabel.text = spot.name;
	cell.detailTextLabel.text = [self.locationManager distanceAndDirectionTo:spot.location];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.visited = [[User currentUser] hasVisitedSpot:spot];

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SpotViewController * viewController = [[[SpotViewController alloc] initWithSpot:[self tableView:tableView spotForRowAtIndexPath:indexPath]] autorelease];
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString];
	self.filteredSpots = [self.spots filteredArrayUsingPredicate:predicate];
	
	return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	controller.searchResultsTableView.tableHeaderView = nil;
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)someSearchBar {
	self.searchDisplayController.searchResultsTableView.tableHeaderView = searchResultsLoadingTableHeaderView;
	
	NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
	[parameters setValue:[someSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
				  forKey:@"q"];
	_spotsSearchRequest = [self spotsRequestForLocation:self.locationManager.location
										 withParameters:parameters];
	[_spotsSearchRequest startAsynchronous];
	[loadingActivityIndicatorView startAnimating];
}

@end

