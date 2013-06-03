//
//  SLView.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 31/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

/**
 This class provides an abstract way of subclassing either a UIView (on iOS) or NSView (on OSX). It also provides custom methods for updating layout or drawing.
 Any components that should work on both iOS and OSX should subclass this class instead of implementing UIView/NSView directly.
 */

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SLView : UIView
#else
@interface SLView : NSView
#endif

/// @abstract		All subclasses should use this method to perform layout as this ensures iOS and OSX get updated correctly.
-(void)layoutViews;

/// @abstract		This ensures setNeedsLayout is called correctly on iOS and OSX
-(void)setLayoutRequired;

/// @abstract		This ensures setNeedsDisplay is called correctly on iOS and OSX.
-(void)setDrawingRequired;

@end
