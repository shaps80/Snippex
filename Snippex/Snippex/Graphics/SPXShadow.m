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

#import "SPXShadow.h"
#import "SPXDrawing.h"
#import "BezierPath+SPXAdditions.h"

#define CODER_OPACITY		@"opacity"
#define CODER_BLUR			@"blur"
#define CODER_OFFSET		@"offset"
#define CODER_PATH			@"path"
#define CODER_COLOR			@"color"

@implementation SPXShadow

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];

	if (self)
	{
        decodeFloat(_shadowOpacity);
        decodeObject(_shadowColor);
        decodeFloat(_shadowBlurRadius);
        decodeObject(_shadowPath);
        decodeSize(_shadowOffset);
	}

	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    encodeFloat(_shadowBlurRadius);
    encodeFloat(_shadowOpacity);
    encodeObject(_shadowColor);
    encodeObject(_shadowPath);
    encodeSize(_shadowOffset);
}

+(SPXShadow *)defaultShadow
{
	static SPXShadow *_defaultShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_defaultShadow = [[self alloc] initWithColor:SPXColorWhiteMake(0, 0.5) offset:CGSizeMake(0, 0) radius:2];
	});

	return _defaultShadow;
}

+(SPXShadow *)darkTextShadowWithAlpha:(CGFloat)alpha
{
	static SPXShadow *_darkTextShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_darkTextShadow = [[self alloc] initWithColor:SPXColorWhiteMake(0, alpha) offset:CGSizeMake(0, -1) radius:0];
	});

	return _darkTextShadow;
}

+(SPXShadow *)darkTextShadow
{
	return [SPXShadow darkTextShadowWithAlpha:0.7];
}

+(SPXShadow *)lightTextShadowWithAlpha:(CGFloat)alpha
{
	static SPXShadow *_lightTextShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_lightTextShadow = [[self alloc] initWithColor:SPXColorWhiteMake(1, 0) offset:CGSizeMake(0, 1) radius:0];
	});

	return _lightTextShadow;
}

+(SPXShadow *)lightTextShadow
{
	return [SPXShadow lightTextShadowWithAlpha:0.5];
}

-(id)initWithColor:(SPXColor *)color offset:(CGSize)offset radius:(CGFloat)radius
{
	self = [super init];

	if (self)
	{
		_shadowColor = color;
#if TARGET_OS_IPHONE
		_shadowOffset = offset;
#else
		_shadowOffset = CGSizeMake(offset.width, -offset.height);
#endif
		_shadowOpacity = 1;
		_shadowBlurRadius = radius;
	}

	return self;
}

-(void)setShadowOffset:(CGSize)offset
{
#if TARGET_OS_IPHONE
	_shadowOffset = offset;
#else
	_shadowOffset = CGSizeMake(offset.width, -offset.height);
#endif
}

-(void)drawDropShadowForPath:(SPXBezierPath *)path fillColor:(SPXColor *)fillColor
{
	drawDropShadowWithFillColor(SPXContext, path.CGPath, _shadowColor.CGColor, fillColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawDropShadowForRect:(CGRect)rect fillColor:(SPXColor *)fillColor
{
	drawDropShadowWithFillColor(SPXContext, [SPXBezierPath bezierPathWithRect:rect].CGPath, _shadowColor.CGColor, fillColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawInnerShadowForPath:(SPXBezierPath *)path
{
	drawInnerShadowPath(SPXContext, path.CGPath, _shadowColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawInnerShadowForRect:(CGRect)rect
{
	drawInnerShadowRect(SPXContext, rect, _shadowColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)set
{
	CGContextSetShadowWithColor(SPXContext, _shadowOffset, _shadowBlurRadius, _shadowColor.CGColor);
}

@end