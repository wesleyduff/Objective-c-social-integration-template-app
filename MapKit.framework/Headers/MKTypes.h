//
//  MKTypes.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
    MKMapTypeStandard = 0,
    MKMapTypeSatellite,
    MKMapTypeHybrid
};
typedef NSUInteger MKMapType;


UIKIT_EXTERN NSString *MKErrorDomain;

enum MKErrorCode {
    MKErrorUnknown = 1,
    MKErrorServerFailure,
    MKErrorLoadingThrottled,
    MKErrorPlacemarkNotFound,
};


