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

#import "SPXShadow.h"

/**
 This class provides convenience methods for constructing common paths and drawing methods to support both __iOS__ and __OSX__.
 */

#if TARGET_OS_IPHONE

@interface UIBezierPath (SPXAdditions)

#else

#import <Cocoa/Cocoa.h>
#import "Color+SPXAdditions.h"

@interface NSBezierPath (SPXAdditions)

#pragma mark -	OSX Specific Methods
/// @name		OSX Specific Methods

/**
 @abstract		Returns a CGPathRef representation of the current path.
 @discussion	This method is specific to OSX since this is already provided by iOS.
 */
- (CGPathRef)CGPath;

/**
 @abstract		Creates a bezier path instance using the specified CGPathRef.
 @param			pathRef The CGPathRef to convert.
 @return		An NSBezierPath instance.
 @discussion	This method is specific to OSX since this is already provided by iOS.
 */
+ (SPXBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef;

#endif

#pragma mark -	Common Paths
/// @name		Common Paths

/**
 @abstract		Returns a path that resembles the iOS back button common in UINavigationBar's.
 @param			rect The rect to layout the path.
 @param			radius The radius of the corners.
 @return		A CGPathRef representation.
 */
+ (CGPathRef)CreatePathForBackButtonInRect:(CGRect)rect withRadius:(CGFloat)radius;

/**
 @abstract		Returns a path with a stroke.
 @param			strokeWidth The width for the stroke.
 @return		An NSBezierPath or UIBezierPath instance.
 @discussion	You can use -setFillColor: and -setStrokeColor: to apply colors to this path.
 */
- (SPXBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth;

#pragma mark -	Drawing Fills
/// @name		Drawing Fills

/**
 @abstract		Draws an inner shadow inside this path.
 @param			shadow The shadow to draw.
 */
- (void)fillWithInnerShadow:(SPXShadow *)shadow;

#pragma mark -	Drawing Strokes
/// @name		Drawing Strokes

/**
 @abstract		Draws a stroke inside this path.
 */
- (void)strokeInside;

/**
 @abstract		Draws a stroke outside this path.
 */
-(void)strokeOutside;

@end
