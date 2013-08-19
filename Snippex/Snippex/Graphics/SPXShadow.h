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

#import <QuartzCore/QuartzCore.h>
#import "SPXDefines.h"
#import "SPXGraphicsDefines.h"
#import "SPXDefines.h"

#if !TARGET_OS_IPHONE
#import "Color+SPXAdditions.h"
#endif

/**
 This class encapsulates the drawing of a core graphics shadow.
 All colors should be passed as either UIColor or NSColor instances since this class is supported on both iOS and OSX.
 You can also use the macro SPXColor to support _both_ platforms. CGColorRef's however are _NOT_ acceptable.
 */

@interface SPXShadow : NSObject <NSCoding>

#pragma mark -	Convenience Initializers
/// @name		Convenience Initializers

/**
 @abstract		Convenience method for returning a shadow with the following settings:
 
	color    ->  [UIColor colorWithWhite:0 alpha:0.5]
	offset   ->  CGSizeMake(0, 0)
	radius   ->  2
 */
+(SPXShadow *)defaultShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:0 alpha:0.7]
	 offset  ->  CGSizeMake(0, -1)
	 radius  ->  0
 */
+(SPXShadow *)darkTextShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:1 alpha:0.5]
	 offset  ->  CGSizeMake(0, 1)
	 radius  ->  0
 */
+(SPXShadow *)lightTextShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:0 alpha:alpha]
	 offset  ->  CGSizeMake(0, -1)
	 radius  ->  0
 
 @param			alpha The alpha value to apply to the color for this shadow
 */
+(SPXShadow *)darkTextShadowWithAlpha:(CGFloat)alpha;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:1 alpha:alpha]
	 offset  ->  CGSizeMake(0, 1)
	 radius  ->  0
 
 @param			alpha The alpha value to apply to the color for this shadow
 */
+(SPXShadow *)lightTextShadowWithAlpha:(CGFloat)alpha;

#pragma mark -	Initializers
/// @name		Initializers

/**
 @abstract		Returns an instance with the specified color, offset and radius.
 
 @param			color The color for this shadow.
 @param			offset The offset for this shadow.
 @param			radius The radius for this shadow.
 */
-(id)initWithColor:(SPXColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

#pragma mark -	Properties
/// @name		Properties

/// @abstract	The offset for this shadow
@property (nonatomic) CGSize shadowOffset;
/// @abstract	The radius for this shadow
@property (nonatomic) CGFloat shadowBlurRadius;
/// @abstract	The color opacity for this shadow
@property (nonatomic) CGFloat shadowOpacity;
/// @abstract	The color for this shadow
@property (nonatomic, STRONG) SPXColor *shadowColor;
/// @abstract	The path for this shadow
@property (nonatomic, STRONG) SPXBezierPath *shadowPath;

#pragma mark -	Drop Shadows
/// @name		Drop Shadows

/**
 @abstract		Draws a drop shadow in the specified path with the given background fillColor
 
 @param			path The path for this shadow.
 @param			fillColor The fillColor to use for the background of this path.
 */
-(void)drawDropShadowForPath:(SPXBezierPath *)path fillColor:(SPXColor *)fillColor;

/**
 @abstract		Draws a drop shadow in the specified rect with the given background fillColor
 
 @param			rect The rect for this shadow.
 @param			fillColor The fillColor to use for the background of this rect.
 */
-(void)drawDropShadowForRect:(CGRect)rect fillColor:(SPXColor *)fillColor;

#pragma mark -	Inner Shadows
/// @name		Inner Shadows

/**
 @abstract		Draws an inner shadow in the specified path.
 
 @param			path The path for this shadow.
 */
-(void)drawInnerShadowForPath:(SPXBezierPath *)path;

/**
 @abstract		Draws a inner shadow in the specified rect.
 
 @param			rect The rect for this shadow.
 */
-(void)drawInnerShadowForRect:(CGRect)rect;

#pragma mark -	Other Methods
/// @name		Other Methods

/// @abstract	Sets the shadow for the current core graphics context.
-(void)set;

@end