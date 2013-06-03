//
//  NSColor+SLAdditions.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 10/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "NSColor+SLAdditions.h"

@implementation NSColor (SLAdditions)

-(CGColorRef)CGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];

    [self getComponents:(CGFloat *)&components];
	CGColorRef color = CGColorCreate(colorSpace, components);

    return (__bridge CGColorRef)(__bridge_transfer id)color;
}

+(NSColor *)colorWithCGColor:(CGColorRef)CGColor
{
    if (CGColor == NULL) return nil;
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end
