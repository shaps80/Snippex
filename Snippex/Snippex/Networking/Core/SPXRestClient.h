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


#import "SPXRestResponse.h"
#import "SPXRestAuthentication.h"
#import "SPXRestTypes.h"


@class SPXRestRequest, SPXRestPayload;


/**
 *  A REST client
 */
@interface SPXRestClient : NSObject


/**
 *  Gets/sets the class responsible for handling HTTP responses
 */
@property (nonatomic, STRONG) id <SPXResponseHandler> responseHandler;


/**
 *  Gets/sets the class responsible for handling authentication
 */
@property (nonatomic, weak) id <SPXRestAuthentication> authenticationHandler;


/**
 *  Sets the maximum allowed concurrent operations
 *
 *  @param count The number of maximum operations
 */
- (void)setMaxConcurrentRequests:(NSInteger)count;


/**
 *  Determines how many requests are allowed to operate concurrently. Defaults to 2
 *
 *  @return The maximum number of allowed concurrent requests
 */
- (NSInteger)maxConcurrentRequests;


/**
 *  Sets the default timeout used for all requests
 *
 *  @param timeout The default timeout (in seconds) for all requests
 */
+ (void)setDefaultTimeoutInterval:(NSTimeInterval)timeout;


/**
 *  The base GET request constructor
 *
 *  @param url        The url for this request
 *  @param parameters The query parameters for this request
 *  @param headers    The HTTP headers for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)get:(NSURL *)url
             parameters:(NSDictionary *)parameters
                headers:(NSDictionary *)headers
             completion:(SPXRestResponseBlock)completion;


/**
 *  The base POST request constructor
 *
 *  @param url        The url for this request
 *  @param payload    The payload for this request
 *  @param headers    The HTTP headers for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)post:(NSURL *)url
                 payload:(id)payload
                 headers:(NSDictionary *)headers
              completion:(SPXRestResponseBlock)completion;


/**
 *  The base PUT request constructor
 *
 *  @param url        The url for this request
 *  @param payload    The payload for this request
 *  @param headers    The HTTP headers for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)put:(NSURL *)url
                payload:(id)payload
                headers:(NSDictionary *)headers
             completion:(SPXRestResponseBlock)completion;


/**
 *  The base DELETE request constructor
 *
 *  @param url        The url for this request
 *  @param headers    The HTTP headers for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)delete:(NSURL *)url
                   headers:(NSDictionary *)headers
                completion:(SPXRestResponseBlock)completion;


/**
 *  Performs the specified request
 *
 *  @param request    The request to perform
 *  @param completion The completion block to execute when this request completes
 *
 *  @return The SPXRestRequest that will be performed, including other updates, such as authentication and payload configuration
 */
- (SPXRestRequest *)performRequest:(SPXRestRequest *)request
                        completion:(SPXRestResponseBlock)completion;


/**
 *  Cancels all inactive requests
 */
- (void)cancelAllRequests;

/**
 *  Suspends all operations
 */
- (void)suspend;

/**
 *  Resumes all operations
 */
- (void)resume;


@end
