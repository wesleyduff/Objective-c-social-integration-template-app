//
//  MKPolygonView.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MKPolygon.h>
#import <MapKit/MKOverlayPathView.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKPolygonView : MKOverlayPathView

- (id)initWithPolygon:(MKPolygon *)polygon;
@property (nonatomic, readonly) MKPolygon *polygon;

@end
