//
//  MKPlacemark.h
//  MapKit
//
//  Copyright 2009 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CLLocation.h>

@class MKPlacemarkInternal;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKPlacemark : NSObject <MKAnnotation> {
@private
    MKPlacemarkInternal *_internal;
}

// An address dictionary is a dictionary in the same form as returned by 
// ABRecordCopyValue(person, kABPersonAddressProperty).
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
       addressDictionary:(NSDictionary *)addressDictionary;

// Can be turned into a formatted address with ABCreateStringWithAddressDictionary.
@property (nonatomic, readonly) NSDictionary *addressDictionary;

@property (nonatomic, readonly) NSString *thoroughfare; // street address, eg 1 Infinite Loop
@property (nonatomic, readonly) NSString *subThoroughfare;
@property (nonatomic, readonly) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readonly) NSString *subLocality; // neighborhood, landmark, common name, etc
@property (nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readonly) NSString *postalCode; // zip code, eg 95014
@property (nonatomic, readonly) NSString *country; // eg. United States
@property (nonatomic, readonly) NSString *countryCode; // eg. US


@end
