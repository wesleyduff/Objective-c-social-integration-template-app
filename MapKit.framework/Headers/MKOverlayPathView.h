//
//  MKOverlayPathView.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKOverlayView.h>

NS_CLASS_AVAILABLE(__MAC_NA, 4_0)
@interface MKOverlayPathView : MKOverlayView {
@package    
    UIColor *_fillColor;
    UIColor *_strokeColor;
    
    CGFloat _lineWidth;
    CGLineJoin _lineJoin;
    CGLineCap _lineCap;
    CGFloat _miterLimit;
    CGFloat _lineDashPhase;
    NSArray *_lineDashPattern;
    
    CGPathRef _path;
}

@property (retain) UIColor *fillColor;
@property (retain) UIColor *strokeColor;

@property CGFloat lineWidth; // defaults to 0, which is MKRoadWidthAtZoomScale(currentZoomScale)
@property CGLineJoin lineJoin; // defaults to kCGLineJoinRound
@property CGLineCap lineCap; // defaults to kCGLineCapRound
@property CGFloat miterLimit; // defaults to 10
@property CGFloat lineDashPhase; // defaults to 0
@property (copy) NSArray *lineDashPattern; // an array of NSNumbers, defaults to nil

// subclassers should override this to create a path and then set it on
// themselves with self.path = newPath;
- (void)createPath;
// returns cached path or calls createPath if path has not yet been created
@property CGPathRef path; // path will be retained
- (void)invalidatePath;

// subclassers may override these
- (void)applyStrokePropertiesToContext:(CGContextRef)context
                           atZoomScale:(MKZoomScale)zoomScale;
- (void)applyFillPropertiesToContext:(CGContextRef)context
                         atZoomScale:(MKZoomScale)zoomScale;
- (void)strokePath:(CGPathRef)path inContext:(CGContextRef)context;
- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context;

@end
