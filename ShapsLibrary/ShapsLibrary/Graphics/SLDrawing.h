//
//  CLDrawingUtilities.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 18/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

/**
 Below are various C methods that ONLY use Core Graphics and Foundation classes to guarantee cross-platform compatibility.
 */

#import <QuartzCore/QuartzCore.h>

#if !TARGET_OS_IPHONE
#import "NSColor+SLAdditions.h"
#endif

// Draws a 1 px line using specified context.
void stroke1PxLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,
                   CGColorRef color);
void stroke1PxRect(CGContextRef context, CGRect rect, CGColorRef color);

// Fill a rect/path with a gradient using the specified context
void fillLinearGradientRect(CGContextRef context, CGRect rect, CFArrayRef colors, CGFloat *locations, CGFloat angle);
void fillRadialGradientRect(CGContextRef context, CGRect rect, CFArrayRef colors, CGFloat *locations, CGPoint center);
void fillLinearGradientPath(CGContextRef context, CGPathRef path, CFArrayRef colors, CGFloat *locations, CGFloat angle);
void fillRadialGradientPath(CGContextRef context, CGPathRef path, CFArrayRef colors, CGFloat *locations, CGPoint center);

// gradient helpers - faster than search CG...
#define CGGradientColorsMake(colors) CLGradientColorsMake(colors)
#define CGGradientLocationsMake(locations) CLGradientLocationsMake(locations)

// returns a CFArrayRef of CGColorRef's from NSColor/UIColor objects.
CFArrayRef CLGradientColorsMake(NSArray *colors);
// returns a C array of CGFloat* of locations for use in a gradient.
CGFloat *CLGradientLocationsMake(NSArray *locations);

// Draws an inner shadow inside a rect/path using the specified context.
void drawInnerShadowRect(CGContextRef context, CGRect rect, CGColorRef color, CGSize offset, CGFloat blur);
void drawInnerShadowPath(CGContextRef context, CGPathRef path, CGColorRef color, CGSize offset, CGFloat blur);
void drawDropShadowPath(CGContextRef context, CGPathRef path, CGColorRef color, CGSize offset, CGFloat blur);
void drawDropShadowRect(CGContextRef context, CGRect rect, CGColorRef color, CGSize offset, CGFloat blur);
void drawDropShadowWithFillColor(CGContextRef context, CGPathRef path, CGColorRef color, CGColorRef fillColor, CGSize offset, CGFloat blur);

// Draw a disclosure indicator (like the one found in UITableViewCell's) using the specified context.
void drawDisclosureIcon(CGContextRef context, CGPoint point, CGColorRef color);