//
//  MKPoint.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKShape.h>
#import <CoreLocation/CLLocation.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKPointAnnotation : MKShape {
@package
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
