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
