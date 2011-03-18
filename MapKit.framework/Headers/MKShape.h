//
//  MKShape.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKShape : NSObject <MKAnnotation> {
@package
    NSString *_title;
    NSString *_subtitle;
}

@property (copy) NSString *title;
@property (copy) NSString *subtitle;

@end
