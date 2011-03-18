//
//  MKMapView.h
//  MapKit
//
//  Important: The MapKit framework uses Google services to provide map data. Use of this class and 
//  the associated interfaces binds you to the Google Maps/Google Earth API terms of service. You can
//  find these terms of service at http://code.google.com/apis/maps/iphone/terms.html
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#import <MapKit/MKAnnotationView.h>
#import <MapKit/MKGeometry.h>
#import <MapKit/MKTypes.h>
#import <MapKit/MKOverlay.h>
#import <MapKit/MKOverlayView.h>
#import <MapKit/MKPointAnnotation.h>
#import <MapKit/MKPolygon.h>
#import <MapKit/MKPolyline.h>
#import <MapKit/MKCircle.h>
#import <MapKit/MKPolygonView.h>
#import <MapKit/MKPolylineView.h>
#import <MapKit/MKCircleView.h>

#import <UIKit/UIKit.h>

@class MKUserLocation;
@class MKMapViewInternal;

@protocol MKMapViewDelegate;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKMapView : UIView <NSCoding>
{
@private
    MKMapViewInternal *_internal;
}

@property (nonatomic, assign) id <MKMapViewDelegate> delegate;

// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;

// Region is the coordinate and span of the map.
// Region may be modified to fit the aspect ratio of the view using regionThatFits:.
@property (nonatomic) MKCoordinateRegion region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated;

// centerCoordinate allows the coordinate of the region to be changed without changing the zoom level.
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

// Returns a region of the aspect ratio of the map view that contains the given region, with the same center point.
- (MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region;

// Access the visible region of the map in projected coordinates.
@property (nonatomic) MKMapRect visibleMapRect;
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate;

// Returns an MKMapRect modified to fit the aspect ratio of the map.
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect;

// Edge padding is the minumum padding on each side around the specified MKMapRect.
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(UIView *)view;
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

// Disable user interaction from zooming or scrolling the map, or both.
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

// Set to YES to add the user location annotation to the map and start updating its location
@property (nonatomic) BOOL showsUserLocation;

// The annotation representing the user's location
@property (nonatomic, readonly) MKUserLocation *userLocation;

// Returns YES if the user's location is displayed within the currently visible map region.
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

// Annotations are models used to annotate coordinates on the map. 
// Implement mapView:viewForAnnotation: on MKMapViewDelegate to return the annotation view for each annotation.
- (void)addAnnotation:(id <MKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;

- (void)removeAnnotation:(id <MKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray *)annotations;

@property (nonatomic, readonly) NSArray *annotations;
- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2);

// Currently displayed view for an annotation; returns nil if the view for the annotation isn't being displayed.
- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation;

// Used by the delegate to acquire an already allocated annotation view, in lieu of allocating a new one.
- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

// Select or deselect a given annotation.  Asks the delegate for the corresponding annotation view if necessary.
- (void)selectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated;
@property (nonatomic, copy) NSArray *selectedAnnotations;

// annotationVisibleRect is the visible rect where the annotations views are currently displayed.
// The delegate can use annotationVisibleRect when animating the adding of the annotations views in mapView:didAddAnnotationViews:
@property (nonatomic, readonly) CGRect annotationVisibleRect;

@end

@interface MKMapView (OverlaysAPI)

// Overlays are models used to represent areas to be drawn on top of the map.
// This is in contrast to annotations, which represent points on the map.
// Implement -mapView:viewForOverlay: on MKMapViewDelegate to return the view for each overlay.
- (void)addOverlay:(id <MKOverlay>)overlay __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)addOverlays:(NSArray *)overlays __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void)removeOverlay:(id <MKOverlay>)overlay __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)removeOverlays:(NSArray *)overlays __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2 __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay aboveOverlay:(id <MKOverlay>)sibling __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)insertOverlay:(id <MKOverlay>)overlay belowOverlay:(id <MKOverlay>)sibling __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@property (nonatomic, readonly) NSArray *overlays __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// Currently displayed view for overlay; returns nil if the view has not been created yet.
- (MKOverlayView *)viewForOverlay:(id <MKOverlay>)overlay __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end

@protocol MKMapViewDelegate <NSObject>
@optional

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end
