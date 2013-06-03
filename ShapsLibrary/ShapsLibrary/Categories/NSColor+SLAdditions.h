//
//  NSColor+SLAdditions.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 10/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 An NSColor category that adds iOS style functionality to OS X 10.7.
 */

@interface NSColor (SLAdditions)

/// @abstract		Gets a CGColorRef value from this UIColor.
@property (nonatomic, readonly) CGColorRef CGColor;

/**
 @abstract			Returns an instance of NSColor from the specified CGColorRef
 @param				CGColor The CGColorRef value to use to create this color.
 @return			An NSColor instance.
 */
+(NSColor *)colorWithCGColor:(CGColorRef)CGColor;

@end