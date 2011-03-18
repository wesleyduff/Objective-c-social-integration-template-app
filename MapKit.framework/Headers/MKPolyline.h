//
//  MKPolyline.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <MapKit/MKMultiPoint.h>
#import <MapKit/MKOverlay.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKPolyline : MKMultiPoint <MKOverlay>

+ (MKPolyline *)polylineWithPoints:(MKMapPoint *)points count:(NSUInteger)count;
+ (MKPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end
