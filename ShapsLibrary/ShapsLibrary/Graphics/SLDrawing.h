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