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

#import "SLGeometry.h"

#pragma mark - Helpers

CGFloat CGFloatScaleFromSize(CGSize fromSize, CGSize toSize)
{
	CGFloat scale = 1.0;

	if (fromSize.width > toSize.width)
		scale = toSize.width / fromSize.width;

	if (fromSize.height > toSize.height)
		scale = fminf(toSize.height / fromSize.height, scale);

	return scale;
}

#pragma	mark - Shapes

CGPathRef CGPathCreateBackButtonInRect(CGContextRef context, CGRect rect, CGFloat cornerRadius, CGFloat arrowWidth, BOOL backArrow)
{
	CGMutablePathRef path = CGPathCreateMutable();

    CGPoint mPoint = CGPointMake(CGRectGetMaxX(rect) - cornerRadius, CGRectGetMinY(rect));
    CGPoint ctrlPoint = mPoint;

	CGPathMoveToPoint(path, NULL, mPoint.x, mPoint.y);
    ctrlPoint.y += cornerRadius;
    mPoint.x += cornerRadius;
    mPoint.y += cornerRadius;

	if (cornerRadius > 0)
		CGPathAddArc(path, NULL, ctrlPoint.x, ctrlPoint.y, cornerRadius, M_PI + M_PI_2, 0, NO);

	mPoint.y = CGRectGetMaxY(rect) - cornerRadius;
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);

	ctrlPoint = mPoint;
    mPoint.y += cornerRadius;
    mPoint.x -= cornerRadius;
    ctrlPoint.x -= cornerRadius;

	if (cornerRadius > 0)
		CGPathAddArc(path, NULL, ctrlPoint.x, ctrlPoint.y, cornerRadius, 0, M_PI_2, NO);

	mPoint.x = CGRectGetMinX(rect) + arrowWidth;
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMidY(rect));

	mPoint.y = CGRectGetMinY(rect);
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);

	CGPathCloseSubpath(path);
	CGAffineTransform transform = CGAffineTransformIdentity;

	if (!backArrow)
	{
		CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, CGRectGetWidth(rect) + CGRectGetMinX(rect) * 2, 0.0);		
		CGContextConcatCTM(context,transform);
	}
	
	CGPathRef finalPath = CGPathCreateCopyByTransformingPath(path, &transform);
	CGPathRelease(path);

	return finalPath;
}

#pragma mark - CGRect

CGRect CGRectSetX(CGRect rect, CGFloat x)
{
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetY(CGRect rect, CGFloat y)
{
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

CGRect CGRectSetWidth(CGRect rect, CGFloat width)
{
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height)
{
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin)
{
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetSize(CGRect rect, CGSize size)
{
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect CGRectSetZeroOrigin(CGRect rect)
{
	return CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
}

CGRect CGRectSetZeroSize(CGRect rect)
{
	return CGRectMake(rect.origin.x, rect.origin.y, 0.0f, 0.0f);
}

CGRect CGRectAspectRectFromScale(CGRect rect, CGFloat newScale, BOOL fromCenter)
{
	CGFloat x = rect.origin.x;
	CGFloat y = rect.origin.y;
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;

	if (fromCenter)
	{
		CGFloat xOffset = ((width * newScale) - width) / 2;
		x = width - xOffset;

		CGFloat yOffset = ((height * newScale) - height) / 2;
		y = height - yOffset;
	}

	width *= newScale;
	height *= newScale;

	return CGRectMake(x, y, width, height);
}

CGRect CGRectAspectRectFromSize(CGRect rect, CGSize newSize, BOOL fromCenter)
{
	CGFloat scale = CGFloatScaleFromSize(rect.size, newSize);
	return CGRectAspectRectFromScale(rect, scale, fromCenter);
}

CGRect CGRectNormalize(CGRect rect)
{
	return CGRectMake(CGRectGetMinX(rect) + 0.5, CGRectGetMinY(rect) + 0.5, CGRectGetWidth(rect) - 1, CGRectGetHeight(rect) - 1);
}

#pragma mark - Sizes

CGSize CGSizeAspectScaledFromSize(CGSize size, CGSize newSize)
{
	CGFloat scale = CGFloatScaleFromSize(size, newSize);
	return CGSizeMake(size.width * scale, size.height * scale);
}

CGSize CGSizeMakeWithScale(CGSize size, CGFloat scale)
{
	return CGSizeMake(size.width * scale, size.height * scale);
}

#pragma mark - Points

CGPoint CGPointGetOriginByCenteringRectWithSize(CGSize size, CGRect parentRect)
{
	return CGPointMake(CGRectGetMidX(parentRect) - size.width / 2,
					   CGRectGetMidY(parentRect) - size.height / 2);
}