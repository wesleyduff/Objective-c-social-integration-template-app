//
//  MKReverseGeocoder.h
//  MapKit
//
//  Important: The MapKit framework uses Google services to provide map data. Use of this class and
//  the associated interfaces binds you to the Google Maps/Google Earth API terms of service. You can
//  find these terms of service at http://code.google.com/apis/maps/iphone/terms.html
//  
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MKTypes.h>

@class MKPlacemark;
@class MKReverseGeocoderInternal;
@protocol MKReverseGeocoderDelegate;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKReverseGeocoder : NSObject {
@private
    MKReverseGeocoderInternal *_internal;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;


// A MKReverseGeocoder object should only be started once.
- (void)start;
- (void)cancel;

@property (nonatomic, assign) id<MKReverseGeocoderDelegate> delegate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;      // the exact coordinate being reverse geocoded.
@property (nonatomic, readonly) MKPlacemark *placemark                  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2); 
@property (nonatomic, readonly, getter=isQuerying) BOOL querying;

@end

@protocol MKReverseGeocoderDelegate <NSObject>
@required
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark;
// There are at least two types of errors:
//   - Errors sent up from the underlying connection (temporary condition)
//   - Result not found errors (permanent condition).  The result not found errors
//     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error;
@end
