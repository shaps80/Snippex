/*
 Copyright (c) 2013 Snippex. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 This class provides an abstract way of subclassing either a UIControl (on iOS) or NSControl (on OSX). It also provides custom methods for updating layout or drawing.
 Any components that should work on both iOS and OSX should subclass this class instead of implementing UIControl/NSControl directly.
 */

#import "SPXDefines.h"

typedef enum
{
    SPXControlStateNormal			= 0,
    SPXControlStateHighlighted		= 1 << 0,
    SPXControlStateDisabled			= 1 << 1,
    SPXControlStateSelected			= 1 << 2,
} SPXControlState;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface SPXControl : UIControl

-(void)layoutSubviews NS_REQUIRES_SUPER;

#else 
@interface SPXControl : NSControl

-(void)layout NS_REQUIRES_SUPER;

#endif

/// @abstract		All subclasses should use this method to perform layout as this ensures iOS and OSX get updated correctly.
-(void)layoutViews;

/// @abstract		This ensures setNeedsLayout is called correctly on iOS and OSX
-(void)setLayoutRequired;

/// @abstract		This ensures setNeedsDisplay is called correctly on iOS and OSX.
-(void)setDrawingRequired;

@end
