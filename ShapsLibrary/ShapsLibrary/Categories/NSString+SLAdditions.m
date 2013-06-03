//
//  NSString+SLAdditions.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 12/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "NSString+SLAdditions.h"

@implementation NSString (SLAdditions)

-(NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding
{
	return [self urlEncodedStringUsingEncoding:encoding ignoreQuerySpecifiers:NO];
}

-(NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding ignoreQuerySpecifiers:(BOOL)ignore
{
	if (ignore)
		return (__bridge_transfer NSString *)
		CFURLCreateStringByAddingPercentEscapes(NULL,
												(__bridge CFStringRef)self,
												NULL,
												(CFStringRef)@"!*'\"();@&+$,%#[]% ",
												CFStringConvertNSStringEncodingToEncoding(encoding));
	else
		return (__bridge_transfer NSString *)
		CFURLCreateStringByAddingPercentEscapes(NULL,
												(__bridge CFStringRef)self,
												NULL,
												(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
												CFStringConvertNSStringEncodingToEncoding(encoding));
}

-(NSDictionary *)queryParametersFromString
{
	NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
	NSArray *queries = [self componentsSeparatedByString:@"&"];

	for (NSString *query in queries)
	{
		NSArray *element = [query componentsSeparatedByString:@"="];
		
		if (element.count > 1)
			[queryParams setObject:[element objectAtIndex:1] forKey:[element objectAtIndex:0]];
	}

	return queryParams;
}

@end
