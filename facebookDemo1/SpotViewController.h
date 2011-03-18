//
//  SpotViewController.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@class Spot;
@class EGOImageView;

@interface SpotViewController : UITableViewController <CLLocationManagerDelegate> {
	Spot * spot;
	NSArray * checkIns;
	
	CLLocationManager * locationManager;
	
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * localityRegionLabel;
	IBOutlet EGOImageView * imageView;
	IBOutlet UIButton * checkInButton;
	IBOutlet MKMapView * mapView;
	IBOutlet UIActivityIndicatorView * loadingActivityIndicatorView;
}

@property (nonatomic, retain) Spot * spot;
@property (nonatomic, retain) NSArray * checkIns;

@property (nonatomic, retain) CLLocationManager * locationManager;

- (id)initWithSpot:(Spot *)someSpot;

- (IBAction)checkIn:(id)sender;

@end