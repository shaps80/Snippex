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

typedef void (^SPXDataCompletionBlock)(NSData *data, NSError *error);

/**
 An NSData category that adds useful functionality manipulating NSData instances.
 */

@interface NSData (SPXAdditions)

#pragma mark -	C Functions
/// @name		C Functions

void *NewBase64Decode(
					  const char *inputBuffer,
					  size_t length,
					  size_t *outputLength);

char *NewBase64Encode(
					  const void *inputBuffer,
					  size_t length,
					  bool separateLines,
					  size_t *outputLength);

#pragma mark -	Objective-C Functions
/// @name		Objective-C Functions

/**
 @abstract		Returns an NSData instance with the specified base64 encoded string.
 @param			string The base64 encoded string.
 */
+(NSData *)dataFromBase64String:(NSString *)string;

/**
 @abstract		Returns a base64 encoded string using this NSData instance.
 */
-(NSString *)base64EncodedString;

/**
 @abstract      Performs an Asynchronous request and returns the data/error in the completion block
 @param         url The url for the request
 @param         body The key/value pairs to pass into the body of this request, pass NIL here to generate a GET request, POST otherwise
 @param         encoding The encoding to use for the body string, if this is a GET request, this value is ignored
 @param         error If an error occurs, it will be stored to this value
 @return        The NSData returned from this request
 */
+(NSData *)dataWithContentsOfURL:(NSURL *)url
                        postBody:(NSDictionary *)body
                        encoding:(NSStringEncoding)encoding
                           error:(out NSError *__autoreleasing *)error;

/**
 @abstract      Performs an Asynchronous request and returns the data/error in the completion block
 @param         url The url for the request
 @param         body The key/value pairs to pass into the body of this request, pass NIL here to generate a GET request, POST otherwise
 @param         encoding The encoding to use for the body string, if this is a GET request, this value is ignored
 @param         completion The completion block to be executed when this request completes
 */
+(void)dataWithContentsOfURL:(NSURL *)url
                    postBody:(NSDictionary *)body
                    encoding:(NSStringEncoding)encoding
                  completion:(SPXDataCompletionBlock)completion;

@end
