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
#import "SPXRestPackage.h"

@class SPXRestRequest;
@class SPXRestResponse;

@protocol SPXResponseHandler <NSObject>
-(NSError *)errorForResponse:(SPXRestResponse *)response;
@end

@interface SPXRestResponse : NSObject

- (id)initWithStatus:(NSInteger)statusCode
        responseData:(NSData *)data
             headers:(NSDictionary *)headers
     originalRequest:(SPXRestRequest *)request
     responseHandler:(id <SPXResponseHandler>)handler;

/**
 The original request that this is the response for.
 */
@property (nonatomic, readonly) SPXRestRequest *originalRequest;

/**
 Returns the raw response data.
 */
@property (nonatomic, readonly) NSData *responseData;

/**
 Returns the data object in its intended content-type, nil if the data cannot be decoded into the expected content-type
 */
@property (nonatomic, readonly) SPXRestPackage *package;

/**
 Returns a dictionary of response headers
 */
@property (nonatomic, readonly) NSDictionary *headers;

/**
 * The HTTP status code.
 */
@property (nonatomic, readonly) NSUInteger statusCode;

/**
 If the request failed, the error associated with the failure, nil otherwise
 */
@property (nonatomic, readonly) NSError *error;

/**
 Localized status description for the HTTP status code
 */
- (NSString *)localizedStatusDescription;

/**
 Indicates that a response was received without error.
 */
- (BOOL)wasSuccessful;

/**
 Returns the named cookie.
 */
- (NSHTTPCookie *)cookieNamed:(NSString *)name;

/**
 Returns the value for the named header.
 */
- (NSString *)valueForHeader:(NSString *)header;

/**
 Returns the value for the named cookie.
 */
- (NSString *)valueForCookie:(NSString *)cookieName;

@end
