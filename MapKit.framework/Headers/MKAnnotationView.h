//
//  MKAnnotationView.h
//  MapKit
//
//  Copyright 2009-2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Post this notification to re-query callout information.
UIKIT_EXTERN NSString *MKAnnotationCalloutInfoDidChangeNotification;

#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

enum {
    MKAnnotationViewDragStateNone = 0,      // View is at rest, sitting on the map.
    MKAnnotationViewDragStateStarting,      // View is beginning to drag (e.g. pin lift)
    MKAnnotationViewDragStateDragging,      // View is dragging ("lift" animations are complete)
    MKAnnotationViewDragStateCanceling,     // View was not dragged and should return to it's starting position (e.g. pin drop)
    MKAnnotationViewDragStateEnding         // View was dragged, new coordinate is set and view should return to resting position (e.g. pin drop)
};

typedef NSUInteger MKAnnotationViewDragState;

#endif // #if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@class MKAnnotationViewInternal;
@protocol MKAnnotation;

NS_CLASS_AVAILABLE(__MAC_NA, 3_0)
@interface MKAnnotationView : UIView
{
@private
    MKAnnotationViewInternal *_internal;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly) NSString *reuseIdentifier;

// Classes that override must call super.
- (void)prepareForReuse;

@property (nonatomic, retain) id <MKAnnotation> annotation;

@property (nonatomic, retain) UIImage *image;

// By default, the center of annotation view is placed over the coordinate of the annotation.
// centerOffset is the offset in pixels from the center of the annotion view.
@property (nonatomic) CGPoint centerOffset;

// calloutOffset is the offset in pixels from the top-middle of the annotation view, where the anchor of the callout should be shown.
@property (nonatomic) CGPoint calloutOffset;

// Defaults to YES. If NO, ignores touch events and subclasses may draw differently.
@property (nonatomic, getter=isEnabled) BOOL enabled;

// Defaults to NO. This gets set/cleared automatically when touch enters/exits during tracking and cleared on up.
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

// Defaults to NO. Becomes YES when tapped on in the map view.
@property (nonatomic, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

// If YES, a standard callout bubble will be shown when the annotation is selected.
// The annotation must have a title for the callout to be shown.
@property (nonatomic) BOOL canShowCallout;

// The left accessory view to be used in the standard callout.
@property (retain, nonatomic) UIView *leftCalloutAccessoryView;

// The right accessory view to be used in the standard callout.
@property (retain, nonatomic) UIView *rightCalloutAccessoryView;

// If YES and the underlying id<MKAnnotation> responds to setCoordinate:, 
// the user will be able to drag this annotation view around the map.
@property (nonatomic, getter=isDraggable) BOOL draggable __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// Automatically set to MKAnnotationViewDragStateStarting, Canceling, and Ending when necessary.
// Implementer is responsible for transitioning to Dragging and None states as appropriate.
@property (nonatomic) MKAnnotationViewDragState dragState __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// Developers targeting iOS 4.2 and after must use setDragState:animated: instead of setDragState:.
- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2);


@end
