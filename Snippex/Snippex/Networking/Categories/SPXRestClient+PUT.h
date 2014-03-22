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

/**
 *  Defines the available PUT request methods
 */
@interface SPXRestClient (PUT)


/**
 *  Returns a PUT request
 *
 *  @param url        The url for this request
 *  @param payload    The payload for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)put:(NSURL *)url
                payload:(id)payload
             completion:(SPXRestResponseBlock)completion;


/**
 *  Returns a PUT request
 *
 *  @param url        The url for this request
 *  @param headers    The HTTP headers for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)put:(NSURL *)url
                headers:(NSDictionary *)headers
             completion:(SPXRestResponseBlock)completion;


/**
 *  Returns a PUT request
 *
 *  @param url        The url for this request
 *  @param completion The completion block to execute when this request completes
 *
 *  @return An instance of SPXRestRequest that encapsulates the request and its properties
 */
- (SPXRestRequest *)put:(NSURL *)url
             completion:(SPXRestResponseBlock)completion;


@end
