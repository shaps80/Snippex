//
//  NSBezierPath+MCAdditions.h
//
//  Created by Sean Patrick O'Brien on 4/1/08.
//  Copyright 2008 MolokoCacao. All rights reserved.
//

#import "SLShadow.h"

/**
 This class provides convenience methods for constructing common paths and drawing methods to support both __iOS__ and __OSX__.
 */

#if TARGET_OS_IPHONE

@interface UIBezierPath (SLAdditions)

#else

#import <Cocoa/Cocoa.h>
#import "NSColor+SLAdditions.h"

@interface NSBezierPath (SLAdditions)

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
+ (SLBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef;

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
- (SLBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth;

#pragma mark -	Drawing Fills
/// @name		Drawing Fills

/**
 @abstract		Draws an inner shadow inside this path.
 @param			shadow The shadow to draw.
 */
- (void)fillWithInnerShadow:(SLShadow *)shadow;

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
