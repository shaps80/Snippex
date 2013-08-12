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

#import "SPXError.h"

static NSDictionary *errors;

@implementation SPXError

+(instancetype)sharedInstance
{
    if (!errors)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"errors" withExtension:@"plist"];
        errors = [[NSDictionary alloc] initWithContentsOfURL:url];
    }

    NSAssert(errors, @"Unable to initialize dictionary: %@", errors);

	static SPXError *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[self alloc] init];
	});

	return _sharedInstance;
}

+ (void)initializePlist:(NSURL *)url
{
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfURL:url];
    return [SPXError initializeDictionary:plist];
}

+ (void)initializeDictionary:(NSDictionary *)dictionary
{
    errors = [dictionary copy];
}

+ (NSString *)domain
{
    return [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingPathExtension:@"Error"];
}

+ (NSError *)errorForCode:(NSInteger)code
{
    NSString *longMessage = [SPXError messageForCode:code];
    NSString *shortMessage = [SPXError shortMessageForCode:code];
    return [NSError errorWithDomain:[SPXError domain] code:code
                           userInfo:@{ NSLocalizedDescriptionKey : longMessage, @"ShortMessage" : shortMessage }];
}

+ (NSString *)messageForCode:(NSInteger)code
{
    return [[errors objectForKey:@(code)] objectForKey:@"LongMessage"];
}

+ (NSString *)shortMessageForCode:(NSInteger)code
{
    return [[errors objectForKey:@(code)] objectForKey:@"ShortMessage"];
}

+ (NSString *)messageForCode:(NSInteger)code withPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    return [NSString stringWithFormat:@"%@%@%@", prefix, [self messageForCode:code], suffix];
}

+ (NSError *)errorForError:(NSError *)error
{
    NSString *longMessage = [SPXError messageForCode:error.code];
    NSString *shortMessage = [SPXError shortMessageForCode:error.code];

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];

    if (longMessage)
        [userInfo setObject:longMessage forKey:NSLocalizedDescriptionKey];
    if (shortMessage)
        [userInfo setObject:shortMessage forKey:@"ShortMessage"];

    return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
}

@end
