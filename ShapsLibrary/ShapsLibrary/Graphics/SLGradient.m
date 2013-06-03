//
//  CLGradient.m
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 18/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

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