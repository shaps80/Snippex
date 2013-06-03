//
//  SLControl.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 31/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "SLControl.h"

@implementation SLControl

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
	// All layout code should be placed in this method.
}

-(void)layoutSubviews
{
	[self layoutViews];
}

-(void)layout
{
	[self layoutViews];
}

@end
