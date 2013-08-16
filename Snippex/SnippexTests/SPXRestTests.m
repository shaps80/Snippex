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
#import <SenTestingKit/SenTestingKit.h>
#import "Snippex.h"

typedef void (^RequestBlock)();

@interface SPXTests : SenTestCase
@end

@implementation SPXTests

- (void)testMultipleRequestsToSameEndpoint
{
    NSString *path = @"http://upload.wikimedia.org/wikipedia/commons/9/9d/243_Ida_large.jpg";

    [[SPXRest client] get:[NSURL URLWithString:path] completion:nil];
    [[SPXRest client] get:[NSURL URLWithString:path] completion:^(SPXRestResponse *response)
    {
        NSAssert(response.statusCode == -30, @"This is the second request, so the status code SHOULD be -30");
        [SPXSemaphore resumeForKey:@"request"];
    }];

    [[SPXRest client] cancelAllRequests];
    [SPXSemaphore pauseForKey:@"request"];
}

@end
