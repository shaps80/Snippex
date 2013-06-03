//
//  CLGradient.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 18/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import "BezierPath+SLAdditions.h"
#import "SLDrawing.h"
#import "SLDefines.h"

/**
 This class encapsulates the drawing of a core graphics gradient. 
 All colors should be passed as either UIColor or NSColor instances since this class is supported on both iOS and OSX. 
 You can also use the macro SLColor to support _both_ platforms. CGColorRef's however are _NOT_ acceptable.
 All angles are assumed to be in _degrees_.
*/

@interface SLGradient : NSObject <NSCoding>
{
@private
	NSArray *_colors;
	CGFloat *_locations;
}

#pragma mark -	Initializers
/// @name		Initializers

/**
 @abstract		Returns an instance with the specified colors.
 @param			startingColor The start color for this gradient.
 @param			endingColor The end color for this gradient.
 */
-(id)initWithStartingColor:(SLColor *)startingColor endingColor:(SLColor *)endingColor;

/**
 @abstract		Returns an instance with the specified colors.
 @param			colors An array of colors to be used for this gradient, these colors will be spaced equally.
 */
-(id)initWithColors:(NSArray *)colors;

/**
 @abstract		Returns an instance with the specified colors and locations.
 @param			colors An array of colors to be used for this gradient.
 @param			locations The locations for each color in this gradient.
 */
-(id)initWithColors:(NSArray *)colors atLocations:(CGFloat *)locations;

#pragma mark -	Linear Gradients
/// @name		Linear Gradients

/**
 @abstract		Draws a linear gradient in the specified rect at the given angle.
 @param			rect The rect to draw this gradient inside.
 @param			angle The angle at which to draw this gradient.
 */
-(void)drawInRect:(CGRect)rect angle:(CGFloat)angle;

/**
 @abstract		Draws a linear gradient within the specified path at the given angle.
 @param			path The path to draw this gradient inside.
 @param			angle The angle at which to draw this gradient.
 */
-(void)drawInBezierPath:(SLBezierPath *)path angle:(CGFloat)angle;

#pragma mark -	Radial Gradients
/// @name		Radial Gradients

/**
 @abstract		Draws a radial gradient inside the specified rect given the relative center.
 @param			rect The rect to draw this gradient inside.
 @param			relativeCenterPosition The relative center start position for this gradient.
 @discussion	Valid relativeCenterPosition values are from -1 to 1, 0 being absolute center.
 */
-(void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition;

/**
 @abstract		Draws a radial gradient inside the specified rect given the relative center.
 @param			path The path to draw this gradient inside.
 @param			relativeCenterPosition The relative center start position for this gradient.
 @discussion	Valid relativeCenterPosition values are from -1 to 1, 0 being absolute center.
 */
-(void)drawInBezierPath:(SLBezierPath *)path relativeCenterPosition:(CGPoint)relativeCenterPosition;

@end