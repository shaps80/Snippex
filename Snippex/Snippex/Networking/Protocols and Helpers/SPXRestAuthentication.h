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
 *  Provides a definition for how authentication is handled by the REST client
 */
@protocol SPXRestAuthentication <NSObject>

@optional

/**
 *  Determines if valid credentials have been supplied
 *
 *  @return YES if the supplied credentials are valid, NO otherwise
 */
- (BOOL)hasValidCredentials;


/**
 *  Specified whether or not authentication should be performed before any request is executed
 *
 *  @param request The request to authenticate
 */
- (void)authenticateBeforePerformingRequest:(SPXRestRequest *)request;

@end


/**
 *  An class for dealing with authentication
 */
@interface SPXRestBasicAuth : NSObject <SPXRestAuthentication>


/**
 *  Initializes an authentication object for handling BASIC authentication
 *
 *  @param username The username to use for authentication
 *  @param password The password to use for authentication
 *
 *  @return An instance of SPXRestBasicAuth
 */
+(instancetype)authWithUsername:(NSString *)username password:(NSString *)password;


@end

