//
//  CLGeometry.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 31/01/13.
//  Copyright (c) 2013 CodeBendaz. All rights reserved.
//

/**
 Below are various C methods that ONLY use Core Graphics and Math classes to guarantee cross-platform compatibility.
 */

#import <math.h>

#define DEGREES_TO_RADIANS(d) ((d) * 0.0174532925199432958f)
#define RADIANS_TO_DEGREES(r) ((r) * 57.29577951308232f)

typedef struct SLOffset {
    CGFloat horizontal, vertical; // specify amount to offset a position, positive for right or down, negative for left or up
} SLOffset;

static inline SLOffset SLOffsetMake(CGFloat horizontal, CGFloat vertical)
{
    SLOffset offset = {horizontal, vertical};
    return offset;
}

// rects - the defines are just so because its faster to lookup CL than all the CG references.
#define CLRectAspectRectFromScale(rect, newScale, isFromCenter) CGRectAspectRectFromScale(rect, newScale, isFromCenter)
#define CLRectAspectRectFromSize(rect, newSize, isFromCenter) CGRectAspectRectFromSize(rect, newSize, isFromCenter)
#define CLRectSetX(rect, x) CGRectSetX(rect, x)
#define CLRectSetY(rect, y) CGRectSetY(rect, y)
#define CLRectSetWidth(rect, width) CGRectSetWidth(rect, width)
#define CLRectSetHeight(rect, height) CGRectSetHeight(rect, height)
#define CLRectSetOrigin(rect, origin) CGRectSetOrigin(rect, origin)
#define CLRectSetSize(rect, size) CGRectSetSize(rect, size)
#define CLRectSetZeroOrigin(rect) CGRectSetZeroOrigin(rect)
#define CLRectSetZeroSize(rect) CGRectSetZeroSize(rect)
#define CLRectNormalize(rect) CGRectNormalize(rect)

inline CGRect CGRectAspectRectFromScale(CGRect rect, CGFloat newScale, BOOL fromCenter);
inline CGRect CGRectAspectRectFromSize(CGRect rect, CGSize newSize, BOOL fromCenter);
inline CGRect CGRectSetX(CGRect rect, CGFloat x);
inline CGRect CGRectSetY(CGRect rect, CGFloat y);
inline CGRect CGRectSetWidth(CGRect rect, CGFloat width);
inline CGRect CGRectSetHeight(CGRect rect, CGFloat height);
inline CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
inline CGRect CGRectSetSize(CGRect rect, CGSize size);
inline CGRect CGRectSetZeroOrigin(CGRect rect);
inline CGRect CGRectSetZeroSize(CGRect rect);
inline CGRect CGRectNormalize(CGRect rect);

// sizes - the defines are just so because its faster to lookup CL than all the CG references.
#define CLSizeAspectScaledFromSize(oldSize, newSize) CGSizeAspectScaledFromSize(oldSize, newSize)
#define CLSizeMakeWithScale(size, scale) CGSizeMakeWithScale(size, scale)

inline CGSize CGSizeAspectScaledFromSize(CGSize size, CGSize newSize);
inline CGSize CGSizeMakeWithScale(CGSize size, CGFloat scale);

// points - the defines are just so because its faster to lookup CL than all the CG references.
#define CLPointGetOriginByCenteringRectOfSize(size, parentRect) CGPointGetOriginByCenteringRectOfSize(size, parentRect)

inline CGPoint CGPointGetOriginByCenteringRectWithSize(CGSize size, CGRect parentRect);

// Returns a CGPathRef of a back button using the specified context
#define CLPathCreateBackButtonInRect(rect, cornerRadius, arrowWidth, backArrow) CGPathCreateBackButtonInRect(rect, cornerRadius, arrowWidth, backArrow)

CGPathRef CGPathCreateBackButtonInRect(CGContextRef context, CGRect rect, CGFloat cornerRadius, CGFloat arrowWidth, BOOL backArrow);
