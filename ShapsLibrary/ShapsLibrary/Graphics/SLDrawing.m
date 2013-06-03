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

#import "SLDrawing.h"
#import "SLGeometry.h"
#import "SLGraphicsDefines.h"

#pragma mark - Shadows

void drawDropShadowWithFillColor(CGContextRef context, CGPathRef path, CGColorRef color, CGColorRef fillColor, CGSize offset, CGFloat blur)
{
	CGContextSaveGState(context);
	{
		CGContextSetShadowWithColor(context, offset, blur, color);
		CGContextSetFillColorWithColor(context, fillColor);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
	}
	CGContextRestoreGState(context);
}

void drawDropShadowPath(CGContextRef context, CGPathRef path, CGColorRef color, CGSize offset, CGFloat blur)
{
	drawDropShadowWithFillColor(context, path, color, color, offset, blur);
}

void drawDropShadowRect(CGContextRef context, CGRect rect, CGColorRef color, CGSize offset, CGFloat blur)
{
	CGPathRef path = CGPathCreateWithRect(rect, NULL);
	drawDropShadowPath(context, path, color, offset, blur);
	CGPathRelease(path);
}

void drawInnerShadowPath(CGContextRef context, CGPathRef visiblePath, CGColorRef color, CGSize offset, CGFloat blur)
{
	CGRect bounds = CGPathGetBoundingBox(visiblePath);
	CGRect outerRect = CGRectInset(bounds, -blur, -blur);
	outerRect = CGRectOffset(outerRect, -offset.width, -offset.height);
	outerRect = CGRectInset(CGRectUnion(outerRect, bounds), -1, -1);

	// Fill this path
	CGContextSetFillColorWithColor(context, [SLColor clearColor].CGColor);
	CGContextAddPath(context, visiblePath);
	CGContextFillPath(context);

	CGContextSaveGState(context);
	{
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathAddRect(path, NULL, outerRect);

		CGPathAddPath(path, NULL, visiblePath);
		CGPathCloseSubpath(path);

		CGContextAddPath(context, visiblePath);
		CGContextClip(context);

		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, offset, blur, color);

		CGContextSetFillColorWithColor(context, color);
		CGContextSaveGState(context);
		CGContextAddPath(context, path);
		CGContextEOFillPath(context);

		CGPathRelease(path);
	}
	CGContextRestoreGState(context);
}

void drawInnerShadowRect(CGContextRef context, CGRect rect, CGColorRef color, CGSize offset, CGFloat blur)
{
	CGPathRef path = CGPathCreateWithRect(rect, NULL);
	drawInnerShadowPath(context, path, color, offset, blur);
	CGPathRelease(path);
}

#pragma mark - Strokes

void stroke1PxLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint,
                   CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

void stroke1PxRect(CGContextRef context, CGRect rect, CGColorRef color)
{
    rect = CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);

    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextStrokeRect(context, rect);
    CGContextRestoreGState(context);
}

#pragma mark - Gradients

void fillRadialGradientRect(CGContextRef context, CGRect rect, CFArrayRef colors, CGFloat *locations, CGPoint center)
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, rect);
	fillRadialGradientPath(context, path, colors, locations, center);
	CGPathRelease(path);
}

void fillLinearGradientRect(CGContextRef context, CGRect rect, CFArrayRef colors, CGFloat *locations, CGFloat angle)
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, rect);
	fillLinearGradientPath(context, path, colors, locations, angle);
	CGPathRelease(path);
}

void fillRadialGradientPath(CGContextRef context, CGPathRef path, CFArrayRef colors, CGFloat *locations, CGPoint center)
{
    CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextClip(context);

    CGRect bounds = CGPathGetBoundingBox(path);
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat radius = sqrtf(powf(width/2, 2)+powf(height/2, 2));

    CGPoint startCenter = CGPointMake(width / 2 + (width * center.x) / 2, height / 2 + (height * center.y) / 2);
    CGPoint endCenter = CGPointMake(width / 2, height / 2);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGContextDrawRadialGradient(context, gradient, startCenter, 0, endCenter, radius, 0);
    CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}

void fillLinearGradientPath(CGContextRef context, CGPathRef path, CFArrayRef colors, CGFloat *locations, CGFloat angle)
{
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextClip(context);

	CGRect rect = CGPathGetBoundingBox(path);
	CGContextRotateCTM(context, DEGREES_TO_RADIANS(angle));

	CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
								kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);

	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	CGContextRestoreGState(context);
}

#pragma mark - Gradient Helpers

CFArrayRef CLGradientColorsMake(NSArray *colors)
{
	CFMutableArrayRef gradientColors = CFArrayCreateMutable(kCFAllocatorDefault, colors.count, &kCFTypeArrayCallBacks);

    for (id color in colors)
        CFArrayAppendValue(gradientColors, ((SLColor *)color).CGColor);

	return gradientColors;
}

CGFloat *CLGradientLocationsMake(NSArray *locations)
{
	CGFloat *gradientLocations = calloc(locations.count, sizeof(CGFloat));

	for (int i = 0; i < locations.count; i++)
		gradientLocations[i] = [[locations objectAtIndex:i] floatValue];

	return gradientLocations;
}

#pragma mark - Shapes

void drawDisclosureIcon(CGContextRef context, CGPoint point, CGColorRef color)
{
    CGContextSaveGState(context);
	const CGFloat R = 4.5;
	CGFloat x = point.x + R;
	CGFloat y = point.y + R;

	CGContextRef ctxt = context;
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapRound);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
