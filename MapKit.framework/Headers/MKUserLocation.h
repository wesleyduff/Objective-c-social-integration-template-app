//
//  MKUserLocation.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@class CLLocation;
@class MKUserLocationInternal;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKUserLocation : NSObject <MKAnnotation> {
  @private
    MKUserLocationInternal *_internal;
}

// Returns YES if the user's location is being updated.
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

// Returns nil if the owning MKMapView's showsUserLocation is NO or the user's location has yet to be determined.
@property (readonly, nonatomic) CLLocation *location;

// The title to be displayed for the user location annotation.
@property (retain, nonatomic) NSString *title;

// The subtitle to be displayed for the user location annotation.
@property (retain, nonatomic) NSString *subtitle;

@end