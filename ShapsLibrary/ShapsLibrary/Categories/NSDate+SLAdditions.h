//
//  NSDate+Extensions.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An NSDate category that adds additional parsing and formatting options.
 */

@interface NSDate (SLAdditions)

/**
 @abstract		Returns a valid NSDate instance using the specified RFC3339 formatted date.

 @param			dateString A valid RFC3339 date as an NSString instance.
 @return		A valid NSDate instance.

 @discussion	Dates should be in the following format 
	
	"yyyy-MM-dd'T'HH:mm:ssZ"
			   or 
	"yyyy-MM-dd'T'HH:mm:ss'Z'"
 */
+(NSDate *)dateFromRFC3339DateString:(NSString *)dateString;

/**
 @abstract		Returns an natural language version of the date. 
 For example:

	"Today", "Yesterday", "Last month", "2 minutes ago"
 */
-(NSString *)naturalLanguageDate;

@end