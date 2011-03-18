//
//  MKOverlayView.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MKGeometry.h>
#import <MapKit/MKOverlay.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKOverlayView : UIView {
@package
    id <MKOverlay> _overlay;
    MKMapRect _boundingMapRect;
    CGAffineTransform _mapTransform;
    id _geometryDelegate;
    id _canDrawCache;
    
    CFTimeInterval _lastTile;
    CFRunLoopTimerRef _scheduledScaleTimer;
    
    struct {
        unsigned int keepAlive:1;
        unsigned int levelCrossFade:1;
        unsigned int drawingDisabled:1;
        unsigned int usesTiledLayer:1;
    } _flags;
}

- (id)initWithOverlay:(id <MKOverlay>)overlay;

@property (nonatomic, readonly) id <MKOverlay> overlay;

// Convert screen points relative to this view to absolute MKMapPoints
- (CGPoint)pointForMapPoint:(MKMapPoint)mapPoint;
- (MKMapPoint)mapPointForPoint:(CGPoint)point;

- (CGRect)rectForMapRect:(MKMapRect)mapRect;
- (MKMapRect)mapRectForRect:(CGRect)rect;

// Return YES if the view is currently ready to draw in the specified rect.
// Return NO if the view will not draw in the specified rect or if the
// data necessary to draw in the specified rect is not available.  In the 
// case where the view may want to draw in the specified rect but the data is
// not available, use setNeedsDisplayInMapRect:zoomLevel: to signal when the
// data does become available.
- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale;

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context;

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect;     

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
                       zoomScale:(MKZoomScale)zoomScale;

@end

// Road widths are typically not drawn to scale on the map.  This function
// returns the approximate width in points of roads at the specified zoomScale.
// The result of this function is suitable for use with CGContextSetLineWidth.
UIKIT_EXTERN CGFloat MKRoadWidthAtZoomScale(MKZoomScale zoomScale) __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_4_0);
