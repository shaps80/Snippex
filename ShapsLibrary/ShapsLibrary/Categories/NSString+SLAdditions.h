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

/**
 An NSString category that adds useful functionality for formatting strings.
 */

@interface NSString (SLAdditions)

/**
 @abstract		Returns a dictionary of key/value pairs constructed from a query string.
 @discussion	The query string should be in the format 
 
	key=value&key=value
 */
-(NSDictionary *)queryParametersFromString;

/**
 @abstract		Returns a URL encoded string using the specified encoding.
 @param			encoding The encoding to use.
 @return		A URL encoded NSString instance.
 */
-(NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding;

/**
 @abstract		Returns a URL encoded string using the specified encoding.
 @param			encoding The encoding to use.
 @param			ignore If yes, will ignore query specifiers such as:
 
	'/', '?', ':', '='

 @return		A URL encoded NSString instance.
 */
-(NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding ignoreQuerySpecifiers:(BOOL)ignore;

@end
