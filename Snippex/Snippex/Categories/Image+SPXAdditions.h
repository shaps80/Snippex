/*
   Copyright (c) 2013 Shaps Mohsenin. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Shaps Mohsenin `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps Mohsenin OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import <objc/message.h>
#import "SPXGraphicsDefines.h"

#ifndef __ACCELERATE__
#import <Accelerate/Accelerate.h>
#else
#warning The Accelerate.framework is required for this project.
#endif

CGImageRef SPXCreateBlurredImageRef(CGImageRef imageRef, CGFloat radius, NSInteger iterations);

#if TARGET_OS_IPHONE
@interface UIImage (SPXImageAdditions)
#else
@interface NSImage (SPXImageAdditions)
#endif

@property (nonatomic, readonly) CGImageRef CGImageRef;

#if TARGET_OS_IPHONE
+ (UIImage *)imageFromCGImageRef:(CGImageRef)image;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSInteger)iterations;
#else
+ (NSImage *)imageFromCGImageRef:(CGImageRef)image;
- (NSImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSInteger)iterations;
#endif

@end

#if TARGET_OS_IPHONE

@interface UIView (SPXImageAdditions)

- (UIImage *)viewAsImage;
- (UIImage *)superviewAsImage;

#else

@interface NSView (SPXImageAdditions)

- (NSImage *)viewAsImage;
- (NSImage *)superviewAsImage;

@end

@interface NSWindow (SPXImageAdditions)

- (NSImage *)windowAsImage;
- (NSImage *)belowWindowAsImage;

- (CGImageRef)windowAsCGImageRef;
- (CGImageRef)belowWindowAsCGImageRef;

#endif

@end