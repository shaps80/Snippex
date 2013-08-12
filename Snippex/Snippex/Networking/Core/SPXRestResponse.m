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

#import "SPXRestResponse.h"
#import "SPXRestRequest.h"

NSDictionary *extractCookiesFromHeaders(NSDictionary *headers, NSURL *url)
{
    if (!headers) return [NSDictionary dictionary];

    NSMutableDictionary *cookies = [NSMutableDictionary dictionary];

    for (NSHTTPCookie *cookie in [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:url])
        [cookies setObject:cookie forKey:cookie.name];

    return cookies;
}

@interface SPXRestResponse ()

@property (nonatomic) NSUInteger statusCode;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *cookies;
@property (nonatomic, weak) id <SPXResponseHandler> handler;
@end

@implementation SPXRestResponse

- (id)initWithStatus:(NSInteger)statusCode
        responseData:(NSData *)data
             headers:(NSDictionary *)headers
     originalRequest:(SPXRestRequest *)request
     responseHandler:(id<SPXResponseHandler>)handler
{
    self = [super init];

    if (self)
    {
        _statusCode = statusCode;
        _responseData = data;
        _headers = headers;
        _cookies = extractCookiesFromHeaders(headers, request.URL);
        _originalRequest = request;
        _handler = handler;
    }

    return self;
}

-(NSString *)description
{
    if (self.error)
        return [NSString stringWithFormat:@"%li | %@", (unsigned long)self.statusCode, self.localizedStatusDescription];
    else
        return [NSString stringWithFormat:@"%li | %@", (unsigned long)self.statusCode, self.package.description];
}

-(NSString *)debugDescription
{
    if (self.error)
        return [NSString stringWithFormat:@"%@", self.error];
    else
        return [NSString stringWithFormat:@"Status: %li\n%@", (unsigned long)self.statusCode, self.package.debugDescription];
}

- (SPXRestPackage *)package
{
    return [SPXRestPackage packageForData:_responseData contentType:[_headers objectForKey:@"Content-Type"]];
}

- (NSString *)localizedStatusDescription
{
    return [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
}

- (NSHTTPCookie *)cookieNamed:(NSString *)name;
{
    return [_cookies objectForKey:name];
}

- (NSString *)valueForHeader:(NSString *)header;
{
    return [_headers objectForKey:header];
}

- (NSString *)valueForCookie:(NSString *)cookieNamed;
{
    return [[self cookieNamed:cookieNamed] value];
}

-(NSError *)error
{
    if (_handler)
        return [_handler errorForResponse:self];
    else
        return _originalRequest.error;
}

- (BOOL)wasSuccessful
{
    return (self.statusCode > 0) &&
        !self.originalRequest.error;
}


@end
