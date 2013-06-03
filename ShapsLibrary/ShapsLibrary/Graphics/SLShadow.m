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

#import "SLShadow.h"
#import "SLDrawing.h"
#import "BezierPath+SLAdditions.h"

#define CODER_OPACITY		@"opacity"
#define CODER_BLUR			@"blur"
#define CODER_OFFSET		@"offset"
#define CODER_PATH			@"path"
#define CODER_COLOR			@"color"

@implementation SLShadow

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];

	if (self)
	{
		_shadowOpacity = [[aDecoder decodeObjectForKey:CODER_OPACITY] floatValue];
		_shadowColor = [aDecoder decodeObjectForKey:CODER_COLOR];
		_shadowBlurRadius = [[aDecoder decodeObjectForKey:CODER_BLUR] floatValue];
		_shadowPath = [aDecoder decodeObjectForKey:CODER_PATH];

#if TARGET_OS_IPHONE
		_shadowOffset = [[aDecoder decodeObjectForKey:CODER_OFFSET] CGSizeValue];
#else
		_shadowOffset = [[aDecoder decodeObjectForKey:CODER_OFFSET] sizeValue];
#endif
	}

	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_shadowPath forKey:CODER_PATH];
	[aCoder encodeObject:@(_shadowBlurRadius) forKey:CODER_BLUR];
	[aCoder encodeObject:@(_shadowOpacity) forKey:CODER_OPACITY];
	[aCoder encodeObject:_shadowColor forKey:CODER_COLOR];

#if TARGET_OS_IPHONE
	[aCoder encodeObject:[NSValue valueWithCGSize:_shadowOffset] forKey:CODER_OFFSET];
#else
	[aCoder encodeObject:[NSValue valueWithSize:_shadowOffset] forKey:CODER_OFFSET];
#endif
}

+(SLShadow *)defaultShadow
{
	static SLShadow *_defaultShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_defaultShadow = [[self alloc] initWithColor:SLColorWhiteMake(0, 0.5) offset:CGSizeMake(0, 0) radius:2];
	});

	return _defaultShadow;
}

+(SLShadow *)darkTextShadowWithAlpha:(CGFloat)alpha
{
	static SLShadow *_darkTextShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_darkTextShadow = [[self alloc] initWithColor:SLColorWhiteMake(0, alpha) offset:CGSizeMake(0, -1) radius:0];
	});

	return _darkTextShadow;
}

+(SLShadow *)darkTextShadow
{
	return [SLShadow darkTextShadowWithAlpha:0.7];
}

+(SLShadow *)lightTextShadowWithAlpha:(CGFloat)alpha
{
	static SLShadow *_lightTextShadow = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_lightTextShadow = [[self alloc] initWithColor:SLColorWhiteMake(1, 0) offset:CGSizeMake(0, 1) radius:0];
	});

	return _lightTextShadow;
}

+(SLShadow *)lightTextShadow
{
	return [SLShadow lightTextShadowWithAlpha:0.5];
}

-(id)initWithColor:(SLColor *)color offset:(CGSize)offset radius:(CGFloat)radius
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

-(void)drawDropShadowForPath:(SLBezierPath *)path fillColor:(SLColor *)fillColor
{
	drawDropShadowWithFillColor(SLContext, path.CGPath, _shadowColor.CGColor, fillColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawDropShadowForRect:(CGRect)rect fillColor:(SLColor *)fillColor
{
	drawDropShadowWithFillColor(SLContext, [SLBezierPath bezierPathWithRect:rect].CGPath, _shadowColor.CGColor, fillColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawInnerShadowForPath:(SLBezierPath *)path
{
	drawInnerShadowPath(SLContext, path.CGPath, _shadowColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)drawInnerShadowForRect:(CGRect)rect
{
	drawInnerShadowRect(SLContext, rect, _shadowColor.CGColor, _shadowOffset, _shadowBlurRadius);
}

-(void)set
{
	CGContextSetShadowWithColor(SLContext, _shadowOffset, _shadowBlurRadius, _shadowColor.CGColor);
}

@end