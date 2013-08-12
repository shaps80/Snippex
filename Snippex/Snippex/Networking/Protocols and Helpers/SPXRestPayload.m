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

#import "SPXRestPayload.h"
#import "NSDictionary+SPXRestQueryString.h"

@interface SPXRestPayload()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *contentType;

@end

@implementation SPXRestPayload

+ (instancetype)payloadWithObject:(id)object
{
    if ([object conformsToProtocol:@protocol(SPXRestPayloadProtocol)])
        return object;

    if ([object respondsToSelector:@selector(dataUsingEncoding:)])
        return [[SPXRestPayload alloc] initWithObject:object encoding:NSUTF8StringEncoding];

    if ([object isKindOfClass:[NSDictionary class]])
        return [[SPXRestPayload alloc] initWithDictionary:object];

    if ([object isKindOfClass:[NSData class]])
        return [[SPXRestPayload alloc] initWithData:object];

    return nil;
}

- (id)initWithObject:(id)object encoding:(NSStringEncoding)encoding
{
    NSAssert([object respondsToSelector:@selector(dataUsingEncoding:)],
             @"Object MUST conform to -dataUsingEncoding:");

    self = [super init];

    if (self)
    {
        _data = [object dataUsingEncoding:encoding];
        _contentType = [@"text/plain" copy];
    }

    return self;
}

- (id)initWithData:(NSData *)data;
{
    self = [super init];

    if (self)
    {
        _data = data;
        _contentType = @"application/octet-stream";
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self)
    {
        // get url encoded values, convert to string
        NSString *string = [dictionary stringWithFormEncodedComponents];
        _data = [string dataUsingEncoding:NSUTF8StringEncoding];
        _contentType = @"application/x-www-form-urlencoded";
    }

    return self;
}

- (NSData *)dataForRequest:(SPXRestRequest *)request
{
    return _data;
}

- (NSString *)contentTypeForRequest:(SPXRestRequest *)request
{
    return _contentType;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ | %@", [self class], _contentType];
}

@end

@implementation SPXRestJSONPayload

+ (instancetype)payloadWithObject:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]])
        return [[SPXRestJSONPayload alloc] initWithJSON:object];

    if ([object isKindOfClass:[NSData class]])
        return [[SPXRestJSONPayload alloc] initWithData:object];

    return nil;
}

- (id)initWithData:(NSData *)data
{
    NSAssert([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil],
             @"Expected JSON data");

    self = [super init];

    if (self)
    {
        self.data = data;
        self.contentType = @"application/json";
    }

    return self;
}

- (id)initWithJSON:(id)JSON
{
    NSAssert([JSON isKindOfClass:[NSDictionary class]],
             @"Expected JSON Dictionary, instead got %@", NSStringFromClass([JSON class]));

    self = [super init];

    if (self)
    {
        self.data = [NSJSONSerialization dataWithJSONObject:JSON
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];

        self.contentType = @"application/json";
    }

    return self;
}

@end

