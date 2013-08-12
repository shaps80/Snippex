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

#import "SPXDefines.h"

#import "SPXRestTypes.h"
#import "SPXRestRequest.h"
#import "SPXRestResponse.h"
#import "SPXRestPayload.h"
#import "SPXRestPackage.h"

#import "SPXRestClient+GET.h"
#import "SPXRestClient+POST.h"
#import "SPXRestClient+PUT.h"
#import "SPXRestClient+DELETE.h"

/**
 This class provides a high level API for using RESTful services
 */
@interface SPXRest : NSObject

/**
 @abstract      Convenience method for constructing a valid NSURL using only strings
 @param         endpoint The endpoing to append to the url (e.g. droplets/123)
 @param         root The base URL (e.g. https://api.digitalocean.com) 
 @discussion    Note you don't need to worry about extra '/' characters or string encoding
 */
+ (NSURL *)URLForEndpoint:(NSString *)endpoint relativeTo:(NSString *)root;

/**
 @return        This class method returns a singleton instance of SPXRestRequest
 */
+ (SPXRestClient *)client;

/**
 @return        This class method returns a new instance of SPXRestRequest
 */
+ (SPXRestClient *)newClient;

/**
 @abstract      Can be used to toggle logging for debug purposes.
 */
+ (void)setLoggingType:(SPXRestLoggingType)type;

/**
 @abstract      Outputs the message to the console only if debug logging is enabled
 @param         message The message to log
 */
+ (void)log:(NSString *)message;

/**
 @abstract      Outputs the message to the console only if debug logging is enabled
 @param         message The message to log
 */
+ (void)logVerbose:(NSString *)message;

@end
