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

@class SPXRestRequest;


/**
 *  This protocol defines payload structure to be used in all SPXRestRequest's
 */
@protocol SPXRestPayloadProtocol <NSObject>


/**
 *  Returns an NSData representation of the body
 *
 *  @param request The request that will contain this payload
 *
 *  @return An NSData instance containing this payload
 */
- (NSData *)dataForRequest:(SPXRestRequest *)request;


/**
 *  Returns the content-type for this request
 *
 *  @param request The request that will contain this payload
 *
 *  @return An NSString instance representing the content-type of this payload
 */
- (NSString *)contentTypeForRequest:(SPXRestRequest *)request;


@end


/**
 *  This object encapsulates the entire payload attached to a request
 */
@interface SPXRestPayload : NSObject <SPXRestPayloadProtocol>


/**
 *  Initializes a default payload object (the object is any class that supports -dataUsingEncoding
 *
 *  @param object The object to add to this payload. This can be an NSDictionary (JSON), NSData, etc...
 *
 *  @return An instance of SPXRestPayload
 */
+ (instancetype)payloadWithObject:(id)object;

@end


/**
 *  Initializes a JSON payload object
 */
@interface SPXRestJSONPayload : SPXRestPayload
@end

