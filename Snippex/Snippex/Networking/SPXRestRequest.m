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

#import "SPXRestRequest.h"
#import "NSString+SPXRestQueryString.h"
#import "NSDictionary+SPXRestQueryString.h"

@interface SPXRestRequest ()

@property (nonatomic, strong) NSMutableDictionary *HTTPheaders;
@property (nonatomic, strong) NSMutableDictionary *HTTPparameters;
@property (nonatomic, strong) NSData *HTTPbody;

@end

@implementation SPXRestRequest

@synthesize currentRequest = _currentRequest;

- (id)initWithURL:(NSURL *)url method:(NSString *)method
{
    self = [super init];

    if (self)
    {
        _currentRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [_currentRequest setHTTPMethod:method];

        _HTTPparameters = [[NSMutableDictionary alloc] init];
        _HTTPheaders = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (NSString *)debugDescription
{
    NSMutableString *description = [[NSMutableString alloc] init];

    [description appendFormat:@"%@ | %@ | %@",
     [self class], _currentRequest.HTTPMethod,
     [NSString stringWithFormat:@"%@://%@%@", _currentRequest.URL.scheme,
                    _currentRequest.URL.host, _currentRequest.URL.path]];

    if (_HTTPparameters.count)
        [description appendFormat:@"\nParameters\n%@", _HTTPparameters];

    if (_HTTPheaders.count)
        [description appendFormat:@"\nHeaders\n%@", _HTTPheaders];

    return description;
}

-(NSMutableURLRequest *)currentRequest
{
    NSURL *url = [[NSURL alloc] initWithScheme:_currentRequest.URL.scheme
                                          host:_currentRequest.URL.host
                                          path:_currentRequest.URL.path];
    NSString *query = [_HTTPparameters stringWithFormEncodedComponents];
    NSString *urlPath = url.absoluteString;

    _currentRequest.URL = [NSURL URLWithString:[urlPath stringByAppendingFormat:@"?%@", query]];
    _currentRequest.allHTTPHeaderFields = _HTTPheaders;
    _currentRequest.HTTPBody = _HTTPbody;

    return _currentRequest;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ | %@ | %@", [self class], _currentRequest.HTTPMethod, _currentRequest.URL];
}

- (void)setHeaders:(NSDictionary *)headers
{
    [self.HTTPheaders setValuesForKeysWithDictionary:headers];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.HTTPheaders setValue:value forKey:field];
}

- (void)setParameters:(NSDictionary *)parameters
{
    [self.HTTPparameters setValuesForKeysWithDictionary:parameters];
}

- (void)setValue:(NSString *)value forParameter:(NSString *)parameter
{
    [self.HTTPparameters setValue:value forKey:parameter];
}

- (void)setPayload:(id<SPXRestPayloadProtocol>)payload
{
    [self setHTTPbody:[payload dataForRequest:self]];
    [self setValue:[payload contentTypeForRequest:self] forHTTPHeaderField:@"Content-Type"];
}

- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies
{
    
}

@end
