//
//  MKPolygon.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MKMultiPoint.h>
#import <MapKit/MKOverlay.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKPolygon : MKMultiPoint <MKOverlay> {
@package
    CLLocationCoordinate2D _centroid;
    NSArray *_interiorPolygons;
    BOOL _isDefinitelyConvex;
}

+ (MKPolygon *)polygonWithPoints:(MKMapPoint *)points count:(NSUInteger)count;
+ (MKPolygon *)polygonWithPoints:(MKMapPoint *)points count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

+ (MKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
+ (MKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

@property (readonly) NSArray *interiorPolygons;

@end
