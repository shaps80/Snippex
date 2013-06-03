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

#import "SLControlOSXTests.h"
#import "SLControl.h"

@implementation SLControlOSXTests

-(void)testClassTypes
{
	STAssertEqualObjects([NSControl class], [SLControl superclass], @"View type returned is invalid");

	NSControl *view1 = [[NSControl alloc] init];
	SLControl *view2 = [[SLControl alloc] init];

	STAssertEqualObjects([view1 class], [view2 superclass], @"View type returned is invalid");
}

-(void)testSelectors
{
	STAssertTrue([SLControl instancesRespondToSelector:@selector(drawRect:)], @"Method is not implemented");
	STAssertTrue([SLControl instancesRespondToSelector:@selector(layout)], @"Method is not implemented");
	STAssertTrue([SLControl instancesRespondToSelector:@selector(setSelected:)], @"Method is not implemented");
}

@end
