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

#import <Foundation/Foundation.h>
#import "SLGraphicsDefines.h"
#import "SLControl.h"

typedef enum
{
	SLBreadCrumbItemPositionStart	= 0,
	SLBreadCrumbItemPositionMiddle	= 1,
	SLBreadCrumbItemPositionEnd		= 2,
} SLBreadCrumbItemPosition;

/**
 This class encapsulates the basic properties for each breadcrumb and also performs its own drawing.
 */

@interface SLBreadCrumbItem : SLControl

/**
 @abstract		Returns an instance with its text set.
 @param			text The string to set for its text.
 @return		An SLBreadCrumbItem instance.
 */
-(id)initWithText:(NSString *)text;

/// @abstract	Gets the position of this item.
@property (nonatomic, readonly) SLBreadCrumbItemPosition position;

/// @abstract	Gets/sets the text of this item.
@property (nonatomic, copy) NSString *text;

@end
