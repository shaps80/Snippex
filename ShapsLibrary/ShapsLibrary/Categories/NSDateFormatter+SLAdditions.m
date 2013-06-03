//
//  NSDateFormatter+Extensions.m
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import "NSDateFormatter+SLAdditions.h"

@implementation NSDateFormatter (SLAdditions)

+(NSDateFormatter *)sharedFormatter
{
	static NSDateFormatter *_sharedFormatter = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedFormatter = [[self alloc] init];
	});

	return _sharedFormatter;
}

@end