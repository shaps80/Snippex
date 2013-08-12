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

#import "SPXImage.h"
#import "SPXRest.h"
#import "NSString+SPXAdditions.h"

@interface SPXImage ()
@property (nonatomic, strong) NSCache *images;
@end

@implementation SPXImage

+(instancetype)sharedInstance
{
	static SPXImage *_sharedInstance = nil;
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
        completion(nil, nil);
        return;
    }

    SPXImage *cache = [SPXImage sharedInstance];
    NSString *identifier = [cache MD5ForURL:url];

    if (!identifier)
    {
        completion(nil, nil);
        return;
    }

    UIImage *image = [cache.images objectForKey:identifier];

    if (image)
    {
        completion(image, nil);
        return;
    }

    NSURL *diskURL = [cache cacheURLForURL:url];
    image = [UIImage imageWithContentsOfFile:[diskURL path]];

    if (image)
    {
        completion(image, nil);
        return;
    }

    [[SPXRest client] get:url completion:^(SPXRestResponse *response)
    {
        if (response.error)
        {
            completion(nil, response.error);
            return;
        }

        completion([UIImage imageWithData:response.responseData], nil);
    }];
}

@end
