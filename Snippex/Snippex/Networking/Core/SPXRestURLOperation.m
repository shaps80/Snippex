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

#import "SPXRestURLOperation.h"
#import "SPXRest.h"

@interface SPXRestURLOperation ()

@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) NSMutableData *data;

- (void)setExecuting:(BOOL)isExecuting;
- (void)setFinished:(BOOL)isFinished;

@end

@implementation SPXRestURLOperation

@synthesize request = _request;
@synthesize response = _response;
@synthesize error = _error;
@synthesize data = _data;

#pragma mark - Lifecycle

- (id)initWithRequest:(NSURLRequest *)request
{
    self = [super init];

    if (self)
    {
        _request = request;
    }

    return self;
}

-(void)start
{
    dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_OS_IPHONE
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
        [SPXRest log:[NSString stringWithFormat:@"Request started | %@", self.description]];
        [SPXRest logVerbose:[NSString stringWithFormat:@"Request started | %@", self.debugDescription]];
    });

    [self setExecuting:YES];

    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];

    if (_connection == nil)
        [self setFinished:YES];

    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];

    [[NSRunLoop currentRunLoop] run];
}

-(NSData *)data
{
    return [_data copy];
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    self.data = [[NSMutableData alloc] init];

    if ([self isCancelled])
    {
        [connection cancel];
        [self finish];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.data)
        self.data = [[NSMutableData alloc] init];

    [_data appendData:data];

    if ([self isCancelled])
    {
        [connection cancel];
        [self finish];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SPXRest log:[NSString stringWithFormat:@"Request failed | %@", self.description]];
        [SPXRest logVerbose:[NSString stringWithFormat:@"Request failed | %@", self.description]];
    });

    self.error = error;
}

#pragma mark - Private

- (void)setExecuting:(BOOL)isExecuting;
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)isFinished;
{
    [self willChangeValueForKey:@"isFinished"];
    [self setExecuting:NO];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];

    dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_OS_IPHONE
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
    });

    if ([self isCancelled])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SPXRest log:[NSString stringWithFormat:@"Request cancelled | %@", self.description]];
            [SPXRest logVerbose:[NSString stringWithFormat:@"Request cancelled | %@", self.description]];
        });
    }
}

#pragma mark - Operation

- (void)finish;
{
    [self setFinished:YES];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)cancelImmediately
{
    [_connection cancel];
    [self finish];
}

@end
