//
//  NSManagedObject+CLAdditions.m
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import "NSManagedObject+SLAdditions.h"

@implementation NSManagedObject (SLAdditions)

-(NSDictionary *)JSONRepresentation
{
	@throw [NSException exceptionWithName:@"JSONRepresentation not overriden" reason:@"You must override JSONRepresentation on your NSManagedObject subclass" userInfo:nil];
	return nil;
}

-(void)setAttributesFromJSON:(NSDictionary *)attributes
{
	@throw [NSException exceptionWithName:@"setAttributesFromJSON: not overriden" reason:@"You must override setAttributesFromJSON: on your NSManagedObject subclass" userInfo:nil];
}

@end