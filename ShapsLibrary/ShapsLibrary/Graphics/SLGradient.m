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

#import "SLGradient.h"

#define CODER_COLORS		@"colors"
#define CODER_LOCATIONS		@"locations"

@interface SLGradient ()
@property (nonatomic) CGColorSpaceRef colorSpace;
@end

@implementation SLGradient

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_colors forKey:CODER_COLORS];
	[aCoder encodeObject:[NSNumber numberWithFloat:*_locations] forKey:CODER_LOCATIONS];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];

	if (self)
	{
		_colors = [aDecoder decodeObjectForKey:CODER_COLORS];
		*_locations = [[aDecoder decodeObjectForKey:CODER_LOCATIONS] floatValue];
	}

	return self;
}

-(id)initWithColors:(NSArray *)colors
{
	self = [super init];

	if (self)
	{
		_colors = [colors copy];
		_locations = calloc(colors.count, sizeof(CGFloat));

		for (int i = 0; i < colors.count; i++)
			_locations[i] = (float)i / (float)(colors.count - 1);
	}

	return self;
}

-(id)initWithStartingColor:(SLColor *)startingColor endingColor:(SLColor *)endingColor
{
	self = [super init];

	if (self)
	{
		_colors = @[startingColor, endingColor];
		_locations = CLGradientLocationsMake(@[@0.0, @1.0]);
	}

	return self;
}

-(id)initWithColors:(NSArray *)colors atLocations:(CGFloat *)locations
{
	self = [super init];

	if (self)
	{
		_colors = [colors copy];
		_locations = calloc(colors.count, sizeof(CGFloat));

		for (int i = 0; i < colors.count; i++)
			_locations[i] = locations[i];
	}

	return self;
}

-(CGColorSpaceRef)colorSpace
{
	if (!_colorSpace)
		_colorSpace = CGColorSpaceCreateDeviceRGB();
	
	return _colorSpace;
}

-(void)dealloc
{
	_colors = nil;
	CGColorSpaceRelease(_colorSpace);
	free(_locations);
}

-(void)drawInRect:(CGRect)rect angle:(CGFloat)angle
{
	[self drawLinearGradientInPath:[SLBezierPath bezierPathWithRect:rect] angle:angle];
}

-(void)drawInBezierPath:(SLBezierPath *)path angle:(CGFloat)angle
{
	[self drawLinearGradientInPath:path angle:angle];
}

-(void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition
{
	[self drawRadialGradientInPath:[SLBezierPath bezierPathWithRect:rect] center:relativeCenterPosition];
}

-(void)drawInBezierPath:(SLBezierPath *)path relativeCenterPosition:(CGPoint)relativeCenterPosition
{
	[self drawRadialGradientInPath:path center:relativeCenterPosition];
}

-(void)drawRadialGradientInPath:(SLBezierPath *)path center:(CGPoint)center
{
	NSAssert(path, @"CLGradient: Invalid path");
	NSAssert(_colors.count > 1, @"CLGradient requires at least 2 colors to be provided");
	
	fillRadialGradientPath(SLContext, path.CGPath, CGGradientColorsMake(_colors), _locations, center);
}

-(void)drawLinearGradientInPath:(SLBezierPath *)path angle:(CGFloat)angle
{
	NSAssert(path, @"CLGradient: Invalid path");
	NSAssert(_colors.count > 1, @"CLGradient requires at least 2 colors to be provided");

	fillLinearGradientPath(SLContext, path.CGPath, CGGradientColorsMake(_colors), _locations, angle);
}

@end