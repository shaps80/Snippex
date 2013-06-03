//
//  NSString+SLAdditions.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 12/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

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
