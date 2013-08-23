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

#import "SPXRestDownloadOperation.h"

@interface SPXRestDownloadOperation ()
@property (nonatomic, copy) SPXRestDownloadProgressBlock progressBlock;
@property (nonatomic, copy) NSURL *destinationURL;
@property (nonatomic, strong) NSError *error;
@end

@implementation SPXRestDownloadOperation

- (id)initWithRequest:(NSURLRequest *)request filePath:(NSString *)filePath progressBlock:(SPXRestDownloadProgressBlock)progress
{
    self = [super initWithRequest:request];
    if (!self) return nil;

    _destinationURL = [NSURL fileURLWithPath:filePath];

    NSAssert(_destinationURL, @"You must profile a valid filePath URL");
    _progressBlock = progress;

    return self;
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    if (_progressBlock)
        _progressBlock(totalBytesWritten, expectedTotalBytes);
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL
{
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtURL:destinationURL toURL:_destinationURL error:&error];
    self.error = error;
    [self finish];
}

@end
