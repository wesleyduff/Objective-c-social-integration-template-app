#import <CoreLocation/CoreLocation.h>

@interface CLLocation (AFExtensions)

- (double)bearingInRadiansTowardsLocation:(CLLocation *)towardsLocation;
- (double)bearingInDegreesTowardsLocation:(CLLocation *)towardsLocation;
- (CLLocation *)locationAtDistance:(CLLocationDistance)atDistance alongBearingInRadians:(double)bearingInRadians;
+ (CLLocation *)locationWithCoordinate:(CLLocationCoordinate2D)someCoordinate;

@end
