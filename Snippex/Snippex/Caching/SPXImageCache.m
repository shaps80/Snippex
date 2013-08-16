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

#import "SPXImageCache.h"
#import "SPXRest.h"
#import "NSString+SPXAdditions.h"

@interface SPXImageCache ()
@property (nonatomic, STRONG) NSCache *images;
@end

@implementation SPXImageCache

+(instancetype)cache
{
	static SPXImageCache *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[self alloc] init];
	});

	return _sharedInstance;
}

- (NSCache *)images
{
    return _images ?: (_images = [[NSCache alloc] init]);
}

- (NSString *)MD5ForURL:(NSURL *)url
{
    return [[url absoluteString] MD5];
}

-(NSURL *)applicationCachesDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)cacheURLForURL:(NSURL *)url
{
    return [[[self applicationCachesDirectory]
             URLByAppendingPathComponent:[self MD5ForURL:url]] filePathURL];
}

+ (void)imageWithURL:(NSURL *)url completion:(SPXImageCacheCompletion)completion
{
    if (!url)
    {
        if (completion) completion(nil, nil);
        return;
    }

    SPXImageCache *cache = [SPXImageCache cache];
    NSString *identifier = [cache MD5ForURL:url];

    if (!identifier)
    {
        if (completion) completion(nil, nil);
        return;
    }

#if TARGET_OS_IPHONE
    __block UIImage *image = [cache.images objectForKey:identifier];
#else
    __block NSImage *image = [cache.images objectForKey:identifier];
#endif


    // if we find it in memory, return it
    if (image)
    {
        if (completion) completion(image, nil);
        return;
    }

    void(^ReturnImage)() = ^(
#if TARGET_OS_IPHONE
                             UIImage *image,
#else
                             NSImage *image,
#endif
                             NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (completion) completion(image, nil);
        });
    };

    // we can use any priority here except DISPATCH_QUEUE_PRIORITY_BACKGROUND since this is I/O throttled
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSURL *diskURL = [cache cacheURLForURL:url];

#if TARGET_OS_IPHONE
        image = [UIImage imageWithContentsOfFile:[diskURL path]];
#else
        image = [[NSImage alloc] initWithContentsOfFile:[diskURL path]];
#endif

        // if we found it on disk, return it
        if (image)
        {
            ReturnImage(image, nil);

            // and add it to memory
            [cache.images setObject:image forKey:identifier];
            return;
        }

        // otherwise download it
        [[SPXRest newClient] get:url completion:^(SPXRestResponse *response)
         {
             if (response.error)
                 ReturnImage(nil, response.error);
             else
             {
#if TARGET_OS_IPHONE
                 image = [UIImage imageWithData:response.responseData];
#else
                 image = [[NSImage alloc] initWithData:response.responseData];
#endif
                 ReturnImage(image, nil);

                 if (image)
                 {
                     // now save it to disk and in memory
                     NSURL *saveURL = [cache cacheURLForURL:url];
                     [response.responseData writeToURL:saveURL atomically:YES];
                     [cache.images setObject:image forKey:identifier];
                 }
             }
         }];
    });
}

@end
