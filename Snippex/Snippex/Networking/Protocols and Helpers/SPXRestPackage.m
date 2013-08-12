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

#import "SPXRestPackage.h"
#import "SPXRest.h"

@interface SPXRestPackage ()

@property (nonatomic, copy) NSData *data;
@property (nonatomic, copy) NSString *contentType;

@end

@implementation SPXRestPackage

+ (instancetype)packageForData:(NSData *)data contentType:(NSString *)contentType
{
    return [[SPXRestPackage alloc] initWithData:data contentType:contentType];
}

- (id)initWithData:(NSData *)data contentType:(NSString *)contentType
{
    self = [super init];

    if (self)
    {
        _data = data;
        _contentType = contentType;
    }

    return self;
}

- (NSString *)contentType
{
    return _contentType;
}

-(NSString *)description
{
    return [self stringRepresentation];
}

-(NSString *)debugDescription
{
    if ([_contentType hasPrefix:@"application/json"])
        return [self JSONRepresentation];
    else
        return [self stringRepresentation];
}

- (id)JSONRepresentation
{
    if (!_data) return nil;

    NSError *error;
    id JSON = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&error];
    if (error) [SPXRest log:[NSString stringWithFormat:@"%@ | Expected content-type: %@", error.localizedDescription, _contentType]];
    return JSON;
}

- (NSString *)stringRepresentation
{
    NSString *string = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if (!string) [SPXRest log:[NSString stringWithFormat:@"SPXRestPackage data doesn't appear to be a valid string | Expected content-type: %@", _contentType]];
    return string;
}

@end
