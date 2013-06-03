//
//  SLView.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 31/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "SLView.h"

@implementation SLView

-(BOOL)isFlipped
{
	return YES;
}

-(void)setLayoutRequired
{
#if TARGET_OS_IPHONE
	[self setNeedsLayout];
#else
	[self setNeedsLayout:YES];
#endif
}

-(void)setDrawingRequired
{
#if !TARGET_OS_IPHONE
	// we have to call layout when on OSX since it won't get called automatically when drawRect is overriden.
	[self setNeedsDisplay:YES];
	[self layoutViews]; 
#else
	[self setNeedsDisplay];
#endif
}

-(void)layoutViews
{
	// All subclasses should use this method to perform layout as this ensures iOS and OSX get updated correctly.
}

-(void)layoutSubviews
{
	[self layoutViews];
#if TARGET_OS_IPHONE
	[super layoutSubviews];
#endif
}

-(void)layout
{
	[self layoutViews];
#if !TARGET_OS_IPHONE
	[super layout];
#endif
}

@end
