//
//  MKGeometry.h
//  MapKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>


typedef struct {
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} MKCoordinateSpan;

typedef struct {
	CLLocationCoordinate2D center;
	MKCoordinateSpan span;
} MKCoordinateRegion;


UIKIT_STATIC_INLINE MKCoordinateSpan MKCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
{
    MKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

UIKIT_STATIC_INLINE MKCoordinateRegion MKCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, MKCoordinateSpan span)
{
	MKCoordinateRegion region;
	region.center = centerCoordinate;
    region.span = span;
	return region;
}

UIKIT_EXTERN MKCoordinateRegion MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);

// Projected geometry is available in iPhone OS 4.0 and later
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

// An MKMapPoint is a coordinate that has been projected for use on the
// two-dimensional map.  An MKMapPoint always refers to a place in the world
// and can be converted to a CLLocationCoordinate2D and back.
typedef struct {
    double x;
    double y;
} MKMapPoint;

typedef struct {
    double width;
    double height;
} MKMapSize;

typedef struct {
    MKMapPoint origin;
    MKMapSize size;
} MKMapRect;

// MKZoomScale provides a conversion factor between MKMapPoints and screen points.
// When MKZoomScale = 1, 1 screen point = 1 MKMapPoint.  When MKZoomScale is
// 0.5, 1 screen point = 2 MKMapPoints.
typedef CGFloat MKZoomScale;

// The map point for the coordinate (-90,180)
UIKIT_EXTERN const MKMapSize MKMapSizeWorld;
// The rect that contains every map point in the world.
UIKIT_EXTERN const MKMapRect MKMapRectWorld;

// Conversion between unprojected and projected coordinates
UIKIT_EXTERN MKMapPoint MKMapPointForCoordinate(CLLocationCoordinate2D coordinate);
UIKIT_EXTERN CLLocationCoordinate2D MKCoordinateForMapPoint(MKMapPoint mapPoint);

// Conversion between distances and projected coordinates
UIKIT_EXTERN CLLocationDistance MKMetersPerMapPointAtLatitude(CLLocationDegrees latitude);
UIKIT_EXTERN double MKMapPointsPerMeterAtLatitude(CLLocationDegrees latitude);

UIKIT_EXTERN CLLocationDistance MKMetersBetweenMapPoints(MKMapPoint a, MKMapPoint b);

UIKIT_EXTERN const MKMapRect MKMapRectNull;

// Geometric operations on MKMapPoint/Size/Rect.  See CGGeometry.h for 
// information on the CGFloat versions of these functions.
UIKIT_STATIC_INLINE MKMapPoint MKMapPointMake(double x, double y) {
    return (MKMapPoint){x, y};
}
UIKIT_STATIC_INLINE MKMapSize MKMapSizeMake(double width, double height) {
    return (MKMapSize){width, height};
}
UIKIT_STATIC_INLINE MKMapRect MKMapRectMake(double x, double y, double width, double height) {
    return (MKMapRect){ MKMapPointMake(x, y), MKMapSizeMake(width, height) };
}
UIKIT_STATIC_INLINE double MKMapRectGetMinX(MKMapRect rect) {
    return rect.origin.x;
}
UIKIT_STATIC_INLINE double MKMapRectGetMinY(MKMapRect rect) {
    return rect.origin.y;
}
UIKIT_STATIC_INLINE double MKMapRectGetMidX(MKMapRect rect) {
    return rect.origin.x + rect.size.width / 2.0;
}
UIKIT_STATIC_INLINE double MKMapRectGetMidY(MKMapRect rect) {
    return rect.origin.y + rect.size.height / 2.0;
}
UIKIT_STATIC_INLINE double MKMapRectGetMaxX(MKMapRect rect) {
    return rect.origin.x + rect.size.width;
}
UIKIT_STATIC_INLINE double MKMapRectGetMaxY(MKMapRect rect) {
    return rect.origin.y + rect.size.height;
}
UIKIT_STATIC_INLINE double MKMapRectGetWidth(MKMapRect rect) {
    return rect.size.width;
}
UIKIT_STATIC_INLINE double MKMapRectGetHeight(MKMapRect rect) {
    return rect.size.height;
}
UIKIT_STATIC_INLINE BOOL MKMapPointEqualToPoint(MKMapPoint point1, MKMapPoint point2) {
    return point1.x == point2.x && point1.y == point2.y;
}
UIKIT_STATIC_INLINE BOOL MKMapSizeEqualToSize(MKMapSize size1, MKMapSize size2) {
    return size1.width == size2.width && size1.height == size2.height;
}
UIKIT_STATIC_INLINE BOOL MKMapRectEqualToRect(MKMapRect rect1, MKMapRect rect2) {
    return 
    MKMapPointEqualToPoint(rect1.origin, rect2.origin) &&
    MKMapSizeEqualToSize(rect1.size, rect2.size);
}

UIKIT_STATIC_INLINE BOOL MKMapRectIsNull(MKMapRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y);
}
UIKIT_STATIC_INLINE BOOL MKMapRectIsEmpty(MKMapRect rect) {
    return MKMapRectIsNull(rect) || (rect.size.width == 0.0 && rect.size.height == 0.0);
}

UIKIT_STATIC_INLINE NSString *MKStringFromMapPoint(MKMapPoint point) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", point.x, point.y];
}

UIKIT_STATIC_INLINE NSString *MKStringFromMapSize(MKMapSize size) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", size.width, size.height];
}

UIKIT_STATIC_INLINE NSString *MKStringFromMapRect(MKMapRect rect) {
    return [NSString stringWithFormat:@"{%@, %@}", MKStringFromMapPoint(rect.origin), MKStringFromMapSize(rect.size)];
}

UIKIT_EXTERN MKMapRect MKMapRectUnion(MKMapRect rect1, MKMapRect rect2);
UIKIT_EXTERN MKMapRect MKMapRectIntersection(MKMapRect rect1, MKMapRect rect2);
UIKIT_EXTERN MKMapRect MKMapRectInset(MKMapRect rect, double dx, double dy);
UIKIT_EXTERN MKMapRect MKMapRectOffset(MKMapRect rect, double dx, double dy);
UIKIT_EXTERN void MKMapRectDivide(MKMapRect rect, MKMapRect *slice, MKMapRect *remainder, double amount, CGRectEdge edge);

UIKIT_EXTERN BOOL MKMapRectContainsPoint(MKMapRect rect, MKMapPoint point);
UIKIT_EXTERN BOOL MKMapRectContainsRect(MKMapRect rect1, MKMapRect rect2);
UIKIT_EXTERN BOOL MKMapRectIntersectsRect(MKMapRect rect1, MKMapRect rect2);

UIKIT_EXTERN MKCoordinateRegion MKCoordinateRegionForMapRect(MKMapRect rect);

UIKIT_EXTERN BOOL MKMapRectSpans180thMeridian(MKMapRect rect);
// For map rects that span the 180th meridian, this returns the portion of the rect
// that lies outside of the world rect wrapped around to the other side of the
// world.  The portion of the rect that lies inside the world rect can be 
// determined with MKMapRectIntersection(rect, MKMapRectWorld).
UIKIT_EXTERN MKMapRect MKMapRectRemainder(MKMapRect rect);

#endif
