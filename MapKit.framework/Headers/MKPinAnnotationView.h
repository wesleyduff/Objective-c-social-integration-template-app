//
//  MKPinAnnotationView.h
//  MapKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#import <MapKit/MKAnnotationView.h>

enum {
    MKPinAnnotationColorRed = 0,
    MKPinAnnotationColorGreen,
    MKPinAnnotationColorPurple
};
typedef NSUInteger MKPinAnnotationColor;

@class MKPinAnnotationViewInternal;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKPinAnnotationView : MKAnnotationView
{
@private
    MKPinAnnotationViewInternal *_pinInternal;
}

@property (nonatomic) MKPinAnnotationColor pinColor;

@property (nonatomic) BOOL animatesDrop;

@end
