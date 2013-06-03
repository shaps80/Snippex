//
//  NSBezierPath+MCAdditions.m
//
//  Created by Sean Patrick O'Brien on 4/1/08.
//  Copyright 2008 MolokoCacao. All rights reserved.
//

#import <objc/runtime.h>
#import "BezierPath+SLAdditions.h"
#import "SLDrawing.h"

const char *PathKey = "PathKey";

#define kHeadWidth			12

#if !TARGET_OS_IPHONE

// remove/comment out this line of you don't want to use undocumented functions
#define MCBEZIER_USE_PRIVATE_FUNCTION

#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
extern CGPathRef CGContextCopyPath(CGContextRef context);
#endif

static void CGPathCallback(void *info, const CGPathElement *element)
{
	NSBezierPath *path = (__bridge NSBezierPath *)(info);
	CGPoint *points = element->points;
	
	switch (element->type) {
		case kCGPathElementMoveToPoint:
		{
			[path moveToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
		case kCGPathElementAddLineToPoint:
		{
			[path lineToPoint:NSMakePoint(points[0].x, points[0].y)];
			break;
		}
		case kCGPathElementAddQuadCurveToPoint:
		{
			// NOTE: This is untested.
			NSPoint currentPoint = [path currentPoint];
			NSPoint interpolatedPoint = NSMakePoint((currentPoint.x + 2*points[0].x) / 3, (currentPoint.y + 2*points[0].y) / 3);
			[path curveToPoint:NSMakePoint(points[1].x, points[1].y) controlPoint1:interpolatedPoint controlPoint2:interpolatedPoint];
			break;
		}
		case kCGPathElementAddCurveToPoint:
		{
			[path curveToPoint:NSMakePoint(points[2].x, points[2].y) controlPoint1:NSMakePoint(points[0].x, points[0].y) controlPoint2:NSMakePoint(points[1].x, points[1].y)];
			break;
		}
		case kCGPathElementCloseSubpath:
		{
			[path closePath];
			break;
		}
	}
}

@interface NSBezierPath ()
@property (nonatomic) CGPathRef path;
@end

@implementation NSBezierPath (SLAdditions)

+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	CGPathApply(pathRef, (__bridge void *)(path), CGPathCallback);
	
	return path;
}

-(CGPathRef)path
{
    return (__bridge CGPathRef)(objc_getAssociatedObject(self, (void *)PathKey));
}

- (void)setPath:(CGPathRef)path
{
    objc_setAssociatedObject(self, (void *) PathKey, CFBridgingRelease(path), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPathRef)CGPath
{
	if (self.path)
		return self.path;
	
	CGMutablePathRef path = CGPathCreateMutable();
	NSInteger elementCount = [self elementCount];

	// The maximum number of points is 3 for a NSCurveToBezierPathElement.
	// (controlPoint1, controlPoint2, and endPoint)
	NSPoint controlPoints[3];
	
	for (unsigned int i = 0; i < elementCount; i++)
	{
		switch ([self elementAtIndex:i associatedPoints:controlPoints])
		{
			case NSMoveToBezierPathElement:
				CGPathMoveToPoint(path, &CGAffineTransformIdentity, 
								  controlPoints[0].x, controlPoints[0].y);
				break;
			case NSLineToBezierPathElement:
				CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 
									 controlPoints[0].x, controlPoints[0].y);
				break;
			case NSCurveToBezierPathElement:
				CGPathAddCurveToPoint(path, &CGAffineTransformIdentity, 
									  controlPoints[0].x, controlPoints[0].y,
									  controlPoints[1].x, controlPoints[1].y,
									  controlPoints[2].x, controlPoints[2].y);
				break;
			case NSClosePathBezierPathElement:
				CGPathCloseSubpath(path);
				break;
			default:
				CGPathCloseSubpath(path);
				NSLog(@"Unknown element at [NSBezierPath (GTMBezierPathCGPathAdditions) cgPath]");
				break;
		};
	}

	self.path = path;
	return (__bridge CGPathRef)(__bridge id)self.path;
}

#else
@implementation UIBezierPath (SLAdditions)
#endif

+(CGPathRef)CreatePathForBackButtonInRect:(CGRect)rect withRadius:(CGFloat)radius
{
	CGMutablePathRef path = CGPathCreateMutable();

    CGPoint mPoint = CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y);
    CGPoint ctrlPoint = mPoint;

	CGPathMoveToPoint(path, NULL, mPoint.x, mPoint.y);
    ctrlPoint.y += radius;
    mPoint.x += radius;
    mPoint.y += radius;

	if (radius > 0)
		CGPathAddArc(path, NULL, ctrlPoint.x, ctrlPoint.y, radius, M_PI + M_PI_2, 0, NO);

	mPoint.y = CGRectGetMaxY(rect) - radius;
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);

	ctrlPoint = mPoint;
    mPoint.y += radius;
    mPoint.x -= radius;
    ctrlPoint.x -= radius;

	if (radius > 0)
		CGPathAddArc(path, NULL, ctrlPoint.x, ctrlPoint.y, radius, 0, M_PI_2, NO);

	mPoint.x = rect.origin.x + kHeadWidth;
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, CGRectGetMidY(rect));

	mPoint.y = rect.origin.y;
	CGPathAddLineToPoint(path, NULL, mPoint.x, mPoint.y);

	CGPathCloseSubpath(path);
	return (__bridge  CGPathRef)(__bridge_transfer id)path;
}

- (SLBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth
{
#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
	SLBezierPath *path = [self copy];
	CGContextRef context = SLContext;
	CGPathRef pathRef = [path CGPath];

	CGContextSaveGState(context);
		
	CGContextBeginPath(context);
	CGContextAddPath(context, pathRef);
	CGContextSetLineWidth(context, strokeWidth);
	CGContextReplacePathWithStrokedPath(context);
	CGPathRef strokedPathRef = CGContextCopyPath(context);
	CGContextBeginPath(context);
	SLBezierPath *strokedPath = [SLBezierPath bezierPathWithCGPath:strokedPathRef];
	
	CGContextRestoreGState(context);
	CFRelease(strokedPathRef);
	
	return strokedPath;
#else
	return nil;
#endif//MCBEZIER_USE_PRIVATE_FUNCTION
}

- (void)fillWithInnerShadow:(SLShadow *)shadow
{
	[shadow drawInnerShadowForPath:self];
}

- (void)strokeInside
{
	float lineWidth = [self lineWidth];

	CGContextSaveGState(SLContext);
    [self setLineWidth:(lineWidth * 2.0)];

	CGContextAddPath(SLContext, self.CGPath);
	CGContextClip(SLContext);
    [self stroke];

	CGContextRestoreGState(SLContext);
    [self setLineWidth:lineWidth];
}

-(void)strokeOutside
{
	float lineWidth = [self lineWidth];

	CGContextSaveGState(SLContext);

	CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
	CGPathRef path = CGPathCreateCopyByTransformingPath(self.CGPath, &transform);
	CGContextAddPath(SLContext, path);

    [self setLineWidth:(lineWidth * 2.0)];
    [self stroke];

	CGContextRestoreGState(SLContext);
	CGPathRelease(path);
    [self setLineWidth:lineWidth];
}

@end