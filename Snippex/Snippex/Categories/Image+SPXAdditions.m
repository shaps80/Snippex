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

#import "Image+SPXAdditions.h"

CGImageRef SPXCreateBlurredImageRef(CGImageRef imageRef, CGFloat radius, NSInteger iterations)
{
    //image must be nonzero size
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    if (floorf(size.width) * floorf(size.height) <= 0.0f) return NULL;

    //boxsize must be an odd integer
    int boxSize = radius;
    if (boxSize % 2 == 0) boxSize ++;

    //create image buffers
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    CFIndex bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);

    //create temp buffer
    void *tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                         NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));

    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);

    for (int i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }

    //free buffers
    free(buffer2.data);
    free(tempBuffer);

    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));

    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);

    CGContextRelease(ctx);
    free(buffer1.data);

    return imageRef;
}

#if TARGET_OS_IPHONE
@implementation UIImage (SPXImageAdditions)
#else
@implementation NSImage (SPXImageAdditions)
#endif

#if !TARGET_OS_IPHONE
- (CGImageRef)CGImageRef
{
	NSData *imageData = [self TIFFRepresentation];
    if (!imageData) return NULL;

    CGImageRef imageRef = [self CGImageForProposedRect:NULL context:nil hints:nil];
    return imageRef;
}
#else
- (CGImageRef)CGImageRef
{
    return self.CGImage;
}
#endif

#if TARGET_OS_IPHONE
+ (UIImage *)imageFromCGImageRef:(CGImageRef)image
{
    return [[UIImage alloc] initWithCGImage:image];
#else
+ (NSImage *)imageFromCGImageRef:(CGImageRef)image
{
    CGRect imageRect = CGRectMake(0.0, 0.0, 0.0, 0.0);

    NSImage *newImage = nil;

    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);

    newImage = [[NSImage alloc] initWithSize:imageRect.size];
    [newImage lockFocus];

    CGContextDrawImage(SPXContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];

    return newImage;
#endif
}

#if TARGET_OS_IPHONE
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSInteger)iterations
{
    CGImageRef imageRef = SPXCreateBlurredImageRef(self.CGImage, radius, iterations);
#else
- (NSImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSInteger)iterations
{
    CGImageRef imageRef = SPXCreateBlurredImageRef(self.CGImageRef, radius, iterations);
#endif

    if (!imageRef) return nil;
    id image;

#if TARGET_OS_IPHONE
    image = [[UIImage alloc] initWithCGImage:imageRef];
#else
    image = [[NSImage alloc] initWithCGImage:imageRef size:self.size];
#endif

    CGImageRelease(imageRef);

    return image;
}

@end

#if TARGET_OS_IPHONE

@implementation UIView (SPXImageAdditions)

- (UIImage *)superviewAsImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -self.frame.origin.x, -self.frame.origin.y);
    [self.superview.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (UIImage *)viewAsImage
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, scale);
    [self.layer renderInContext:SPXContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#else

@implementation NSView (SPXImageAdditions)

- (NSImage *)viewAsImage
{
    return [[NSImage alloc] initWithData:[self dataWithPDFInsideRect:[self bounds]]];
}

- (NSImage *)superviewAsImage
{
    return [[NSImage alloc] initWithData:[self.superview dataWithPDFInsideRect:[self.superview bounds]]];
}

@end

@implementation NSWindow (SPXImageAdditions)

- (NSImage *)windowAsImage
{
    CGImageRef windowImage = [self windowAsCGImageRef];
    NSImage *image = [NSImage imageFromCGImageRef:windowImage];
    return image;
}

- (CGImageRef)windowAsCGImageRef
{
    CGWindowID windowID = (CGWindowID)[self windowNumber];
    CGWindowImageOption imageOptions = kCGWindowImageDefault;
    CGWindowListOption singleWindowListOptions = kCGWindowListOptionIncludingWindow;
    CGRect imageBounds = CGRectNull;
    CGImageRef windowImage = CGWindowListCreateImage(imageBounds, singleWindowListOptions, windowID, imageOptions);
    CFAutorelease(windowImage);
    return windowImage;
}

- (NSImage *)belowWindowAsImage
{
    return [NSImage imageFromCGImageRef:[self belowWindowAsCGImageRef]];
}

- (CGImageRef)belowWindowAsCGImageRef
{
    CGWindowID windowID = (CGWindowID)[self windowNumber];
    CGRect windowRect = NSRectToCGRect([self frame]);
    windowRect.origin.y = NSMaxY([[self screen] frame]) - NSMaxY([self frame]);

    CGImageRef capturedImage = CGWindowListCreateImage(windowRect, kCGWindowListOptionOnScreenBelowWindow, windowID, kCGWindowImageDefault);

    if (CGImageGetWidth(capturedImage) <= 1)
    {
        CGImageRelease(capturedImage);
        return nil;
    }

    CFAutorelease(capturedImage);
    return capturedImage;
}

#endif

@end
