//
//  NSData+SLAdditions.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 8/04/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An NSData category that adds useful functionality manipulating NSData instances.
 */

@interface NSData (SLAdditions)

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

@end
