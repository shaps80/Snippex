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

#import "SPXControl.h"

@implementation SPXControl

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

#if TARGET_OS_IPHONE

-(void)layoutSubviews
{
	[self layoutViews];
}

#else

-(void)layout
{
	[self layoutViews];
}

#endif

@end
