//
//  MKPolylineView.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MKPolyline.h>
#import <MapKit/MKOverlayPathView.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKPolylineView : MKOverlayPathView

- (id)initWithPolyline:(MKPolyline *)polyline;

@property (nonatomic, readonly) MKPolyline *polyline;

@end
