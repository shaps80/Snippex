/*
 Copyright (c) 2013 Shaps. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Shaps `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <QuartzCore/QuartzCore.h>
#import "SLDefines.h"

#if !TARGET_OS_IPHONE
#import "NSColor+SLAdditions.h"
#endif

/**
 This class encapsulates the drawing of a core graphics shadow.
 All colors should be passed as either UIColor or NSColor instances since this class is supported on both iOS and OSX.
 You can also use the macro SLColor to support _both_ platforms. CGColorRef's however are _NOT_ acceptable.
 */

@interface SLShadow : NSObject <NSCoding>

#pragma mark -	Convenience Initializers
/// @name		Convenience Initializers

/**
 @abstract		Convenience method for returning a shadow with the following settings:
 
	color    ->  [UIColor colorWithWhite:0 alpha:0.5]
	offset   ->  CGSizeMake(0, 0)
	radius   ->  2
 */
+(SLShadow *)defaultShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:0 alpha:0.7]
	 offset  ->  CGSizeMake(0, -1)
	 radius  ->  0
 */
+(SLShadow *)darkTextShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:1 alpha:0.5]
	 offset  ->  CGSizeMake(0, 1)
	 radius  ->  0
 */
+(SLShadow *)lightTextShadow;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:0 alpha:alpha]
	 offset  ->  CGSizeMake(0, -1)
	 radius  ->  0
 
 @param			alpha The alpha value to apply to the color for this shadow
 */
+(SLShadow *)darkTextShadowWithAlpha:(CGFloat)alpha;

/**
 @abstract		Convenience method for returning a shadow with the following settings:

	 color   ->  [UIColor colorWithWhite:1 alpha:alpha]
	 offset  ->  CGSizeMake(0, 1)
	 radius  ->  0
 
 @param			alpha The alpha value to apply to the color for this shadow
 */
+(SLShadow *)lightTextShadowWithAlpha:(CGFloat)alpha;

#pragma mark -	Initializers
/// @name		Initializers

/**
 @abstract		Returns an instance with the specified color, offset and radius.
 
 @param			color The color for this shadow.
 @param			offset The offset for this shadow.
 @param			radius The radius for this shadow.
 */
-(id)initWithColor:(SLColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

#pragma mark -	Properties
/// @name		Properties

/// @abstract	The offset for this shadow
@property (nonatomic) CGSize shadowOffset;
/// @abstract	The radius for this shadow
@property (nonatomic) CGFloat shadowBlurRadius;
/// @abstract	The color opacity for this shadow
@property (nonatomic) CGFloat shadowOpacity;
/// @abstract	The color for this shadow
@property (nonatomic, strong) SLColor *shadowColor;
/// @abstract	The path for this shadow
@property (nonatomic, strong) SLBezierPath *shadowPath;

#pragma mark -	Drop Shadows
/// @name		Drop Shadows

/**
 @abstract		Draws a drop shadow in the specified path with the given background fillColor
 
 @param			path The path for this shadow.
 @param			fillColor The fillColor to use for the background of this path.
 */
-(void)drawDropShadowForPath:(SLBezierPath *)path fillColor:(SLColor *)fillColor;

/**
 @abstract		Draws a drop shadow in the specified rect with the given background fillColor
 
 @param			rect The rect for this shadow.
 @param			fillColor The fillColor to use for the background of this rect.
 */
-(void)drawDropShadowForRect:(CGRect)rect fillColor:(SLColor *)fillColor;

#pragma mark -	Inner Shadows
/// @name		Inner Shadows

/**
 @abstract		Draws an inner shadow in the specified path.
 
 @param			path The path for this shadow.
 */
-(void)drawInnerShadowForPath:(SLBezierPath *)path;

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