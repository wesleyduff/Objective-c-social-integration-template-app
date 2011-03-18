//
//  MKCircleView.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MKCircle.h>
#import <MapKit/MKOverlayPathView.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKCircleView : MKOverlayPathView

- (id)initWithCircle:(MKCircle *)circle;

@property (nonatomic, readonly) MKCircle *circle;

@end
