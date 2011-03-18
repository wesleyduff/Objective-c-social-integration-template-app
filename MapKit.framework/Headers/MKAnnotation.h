//
//  MKAnnotation.h
//  MapKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol MKAnnotation <NSObject>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

// Title and subtitle for use by selection UI.
- (NSString *)title;
- (NSString *)subtitle;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end
