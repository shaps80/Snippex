//
//  SLControl.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 31/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

/**
 This class provides an abstract way of subclassing either a UIControl (on iOS) or NSControl (on OSX). It also provides custom methods for updating layout or drawing.
 Any components that should work on both iOS and OSX should subclass this class instead of implementing UIControl/NSControl directly.
 */

typedef enum
{
    SLControlStateNormal			= 0,
    SLControlStateHighlighted		= 1 << 0,
    SLControlStateDisabled			= 1 << 1,
    SLControlStateSelected			= 1 << 2,
} SLControlState;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SLControl : UIControl
#else 
@interface SLControl : NSControl
#endif

/// @abstract		All subclasses should use this method to perform layout as this ensures iOS and OSX get updated correctly.
-(void)layoutViews;

/// @abstract		This ensures setNeedsLayout is called correctly on iOS and OSX
-(void)setLayoutRequired;

/// @abstract		This ensures setNeedsDisplay is called correctly on iOS and OSX.
-(void)setDrawingRequired;

@end
