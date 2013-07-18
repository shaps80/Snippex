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

#import "Color+SPXAdditions.h"
#import "SPXGraphicsDefines.h"

@implementation SPXColor (SPXAdditions)

#if !TARGET_OS_IPHONE

// This is to supress warnings when compiling on 10.8+ because these methods are already provided by the SDK.
// These should be removed soon since we no longer need to support 10.7

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

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

#pragma clang diagnostic pop

#endif

+(SPXColor *)colorWithHexValue:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:value];
    [scanner scanHexInt:&rgbValue];

#if TARGET_OS_IPHONE
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0xFF00) >> 8) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
#else
    return [NSColor colorWithCalibratedRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                                     green:((rgbValue & 0xFF00) >> 8) / 255.0
                                      blue:(rgbValue & 0xFF) / 255.0
                                     alpha:1];
#endif
}

@end