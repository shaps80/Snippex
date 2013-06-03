//
//  NSDictionary+SLAdditions.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 20/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An NSDictionary category that adds useful functionality.
 */

@interface NSDictionary (SLAdditions)

/**
 @abstract		Returns a URL query string with the following format:
	
	key=value&key=value
 */
-(NSString*)queryString;

@end
