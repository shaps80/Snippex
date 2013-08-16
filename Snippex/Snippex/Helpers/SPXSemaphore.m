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

#import "SPXSemaphore.h"

@interface SPXSemaphore ()
@property (nonatomic, STRONG) NSMutableArray *keys;
@end

@implementation SPXSemaphore

+(instancetype)sharedInstance
{
	static SPXSemaphore *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[self alloc] init];
	});

	return _sharedInstance;
}

- (NSMutableArray *)keys
{
    return _keys ?: (_keys = [[NSMutableArray alloc] init]);
}

- (BOOL)isPausedForKey:(NSString *)key
{
    return [_keys containsObject:key];
}

- (void)pauseForKey:(NSString *)key
{
    BOOL keepRunning = YES;

    while (keepRunning && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]])
        keepRunning = [[SPXSemaphore sharedInstance] isPausedForKey:key];

    NSLog(@"Finished");
}

- (void)resumeForKey:(NSString *)key
{
    [_keys removeObject:key];
}   

+ (BOOL)isPausedForKey:(NSString *)key
{
    return [[SPXSemaphore sharedInstance] isPausedForKey:key];
}

+ (void)pauseForKey:(NSString *)key
{
    [[SPXSemaphore sharedInstance] pauseForKey:key];
}

+ (void)resumeForKey:(NSString *)key
{
    [[SPXSemaphore sharedInstance] resumeForKey:key];
}

@end
