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
#import "SPXRestResponse.h"
#import "SPXRestPayload.h"


/**
 *  Encapsulates a REST request operation
 */
@interface SPXRestRequest : SPXRestURLOperation


/**
 *  The url for this request (this property is readonly)
 */
@property (nonatomic, readonly) NSURL *URL;


/**
 *  All HTTP Headers associated with this request (this property is readonly)
 */
@property (nonatomic, readonly) NSDictionary *allHTTPHeaders;


/**
 *  Initializes a REST request.
 *
 *  @param url    The url for this request
 *  @param method The HTTP method for this request
 *
 *  @return An instance of SPXRestRequest
 */
- (instancetype)initWithURL:(NSURL *)url method:(NSString *)method;


/**
 *  Specifies the timeout duration for this request
 *
 *  @param timeout The time (in seconds) before this request will timeout
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeout;


/**
 *  Sets the object responsible for handling the response for this request
 *
 *  @param handler The object to handle responses
 */
- (void)setResponseHandler:(id <SPXResponseHandler>)handler;


/**
 *  Sets the payload for this request.
 *
 *  @param payload The payload encapsules the content, settings, etc.. for this request
 */
- (void)setPayload:(id <SPXRestPayloadProtocol>)payload;


/**
 *  Sets the headers for this request
 *
 *  @param headers The header for this request
 */
- (void)setHeaders:(NSDictionary *)headers;


/**
 *  Sets (overriding if necessary) the value for the specified header field
 *
 *  @param value The value for this header
 *  @param field The header field
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 *  Sets the query parameters for this request
 *
 *  @param parameters The parameters to be appended to the end of the URL string
 */
- (void)setParameters:(NSDictionary *)parameters;


/**
 *  Sets the value of the specified parameter
 *
 *  @param value     The value for this parameter
 *  @param parameter The parameter to apply this value to
 */
- (void)setValue:(NSString *)value forParameter:(NSString *)parameter;


/**
 *  Sets whether to automatically handle cookies or not.
 *
 *  @param shouldHandleCookies If YES, will automatically handle cookies, if NO you will be required to handle cookies via the package object
 */
- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies;


@end
