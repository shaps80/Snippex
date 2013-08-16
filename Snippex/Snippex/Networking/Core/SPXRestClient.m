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

#import "SPXRestClient.h"
#import "SPXRestRequest.h"

@interface SPXRestClient ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation SPXRestClient

- (NSOperationQueue *)queue
{
    return _queue ?: (_queue = [[NSOperationQueue alloc] init]);
}

-(void)setMaxConcurrentRequests:(NSInteger)count
{
    [self.queue setMaxConcurrentOperationCount:count];
}

static NSTimeInterval __defaultTimeoutInterval = 10;

+ (void)setDefaultTimeoutInterval:(NSTimeInterval)timeout
{
    __defaultTimeoutInterval = timeout;
}

- (SPXRestRequest *)get:(NSURL *)url
             parameters:(NSDictionary *)parameters
                headers:(NSDictionary *)headers
             completion:(SPXRestResponseBlock)completion
{
    SPXRestRequest *request = [self requestForURL:url method:@"GET" payload:nil headers:headers];
    [request setParameters:parameters];
    return [self performRequest:request completion:completion];
}

- (SPXRestRequest *)post:(NSURL *)url
                 payload:(id)payload
                 headers:(NSDictionary *)headers
              completion:(SPXRestResponseBlock)completion
{
    return [self performRequest:[self requestForURL:url method:@"POST" payload:payload headers:headers] completion:completion];
}

- (SPXRestRequest *)put:(NSURL *)url
                payload:(id)payload
                headers:(NSDictionary *)headers
             completion:(SPXRestResponseBlock)completion
{
    return [self performRequest:[self requestForURL:url method:@"PUT" payload:payload headers:headers] completion:completion];
}

- (SPXRestRequest *)delete:(NSURL *)url
                   headers:(NSDictionary *)headers
                completion:(SPXRestResponseBlock)completion
{
    return [self performRequest:[self requestForURL:url method:@"DELETE" payload:nil headers:headers] completion:completion];
}

- (SPXRestRequest *)performRequest:(SPXRestRequest *)request
                        completion:(SPXRestResponseBlock)completion
{
    if ([_authenticationHandler respondsToSelector:@selector(authenticateBeforePerformingRequest:)])
        [_authenticationHandler authenticateBeforePerformingRequest:request];

    [request setResponseHandler:_responseHandler];
    request.responseCompletionBlock = completion;
    [self.queue addOperation:request];
    return request;
}

- (void)cancelAllRequests
{
    [_queue cancelAllOperations];
}

#pragma mark - Private

- (SPXRestRequest *)requestForURL:(NSURL *)url method:(NSString *)method payload:(id <SPXRestPayloadProtocol>)payload headers:(NSDictionary *)headers
{
    SPXRestRequest *request = [[SPXRestRequest alloc] initWithURL:url method:method];

    [request setPayload:[SPXRestPayload payloadWithObject:payload]];
    [request setHeaders:headers];
    [request setTimeoutInterval:__defaultTimeoutInterval];

    return request;
}

@end
