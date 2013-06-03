//
//  NSDictionary+SLAdditions.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 20/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "NSDictionary+SLAdditions.h"

// helper function: get the string form of any object
static NSString *toString(id object)
{
	return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object)
{
	NSString *string = toString(object);
	return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@implementation NSDictionary (SLAdditions)

-(NSString*) queryString
{
	NSMutableArray *parts = [NSMutableArray array];

	for (id key in self)
	{
		id value = [self objectForKey:key];
		NSString *part = [NSString stringWithFormat:@"%@=%@", urlEncode(key), urlEncode(value)];
		[parts addObject:part];
	}

	return [parts componentsJoinedByString:@"&"];
}

@end
