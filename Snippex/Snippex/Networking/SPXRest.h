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

#ifndef _RESTCLIENT_H
#define _RESTCLIENT_H

#import "SPXDefines.h"
#import "SPXRestTypes.h"
#import "SPXRestRequest.h"
#import "SPXRestClient+GET.h"
#import "SPXRestClient+POST.h"
#import "SPXRestClient+PUT.h"
#import "SPXRestClient+DELETE.h"


extern SPXRestLoggingType SPXSharedRestClientLoggingType;

#define SPXRestLog(format, ...) if (SPXSharedRestClientLoggingType == SPXRestLoggingTypeConcise) { SPXLog(format, ##__VA_ARGS__); }
#define SPXRestLogVerbose(format, ...) if (SPXSharedRestClientLoggingType == SPXRestLoggingTypeVerbose) { SPXLog(format, ##__VA_ARGS__); }


@class SPXRestClient, SPXRestRequest, SPXRestRequest, SPXRestPackage, SPXRestPayload;


/**
 *  This class provides a high level API for using RESTful services
 */
@interface SPXRest : NSObject


/**
*  Convenience method for constructing a valid NSURL using only strings
*
*  @param endpoint The endpoing to append to the url (e.g. droplets/123)
*  @param root     The base URL (e.g. https://api.digitalocean.com)
*
*  @return Note you don't need to worry about extra '/' characters or string encoding
*/
+ (NSURL *)URLForEndpoint:(NSString *)endpoint relativeTo:(NSString *)root;


/**
 *  This class method returns the default singleton instance of SPXRestRequest
 *
 *  @return A default singleton instance of SPXRestClient
 */
+ (SPXRestClient *)client;


/**
 *  This class method returns a new instance of SPXRestRequest
 *
 *  @return An new instance of SPXRestClient
 */
+ (SPXRestClient *)newClient;


/**
 *  Can be used to toggle logging for debug purposes.
 *
 *  @param type The logging level
 */
+ (void)setLoggingType:(SPXRestLoggingType)type;


@end

#endif
