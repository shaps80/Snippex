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
#import "SPXRest.h"
#import "NSString+SPXRestQueryString.h"
#import "NSDictionary+SPXRestQueryString.h"

@interface SPXRestRequest ()

@property (nonatomic, STRONG, readonly) NSMutableURLRequest *currentRequest;
@property (nonatomic, STRONG) NSMutableDictionary *HTTPparameters;
@property (nonatomic, weak) id <SPXResponseHandler> responseHandler;

@end

@implementation SPXRestRequest

@synthesize currentRequest = _currentRequest;

- (id)initWithURL:(NSURL *)url method:(NSString *)method
{
  self = [super init];
  
  if (self)
  {
    _currentRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [_currentRequest setTimeoutInterval:10];
    [_currentRequest setHTTPMethod:method];
    
    _HTTPparameters = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeout
{
  [_currentRequest setTimeoutInterval:timeout];
}

-(NSURL *)URL
{
  return _currentRequest.URL;
}

-(NSDictionary *)allHTTPHeaders
{
  return _currentRequest.allHTTPHeaderFields;
}

- (NSString *)debugDescription
{
  NSMutableString *description = [[NSMutableString alloc] init];
  
  [description appendFormat:@"%@ | %@",
   _currentRequest.HTTPMethod,
   [NSString stringWithFormat:@"%@://%@%@", _currentRequest.URL.scheme,
    _currentRequest.URL.host, _currentRequest.URL.path]];
  
  if (_HTTPparameters.count)
    [description appendFormat:@"\nParameters\n%@", _HTTPparameters];
  
  if (_currentRequest.allHTTPHeaderFields.count)
    [description appendFormat:@"\nHeaders\n%@", _currentRequest.allHTTPHeaderFields];
  
  return description;
}

-(void)updateParameters
{
  NSURL *url = [_currentRequest.URL copy];
  NSString *query = [_HTTPparameters stringWithFormEncodedComponents];
  NSString *urlPath = url.absoluteString;
  
  _currentRequest.URL = [NSURL URLWithString:[urlPath stringByAppendingFormat:@"?%@", query ?: @""]];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@", _currentRequest.URL.absoluteString];
}

- (void)setHeaders:(NSDictionary *)headers
{
  [_currentRequest.allHTTPHeaderFields setValuesForKeysWithDictionary:headers];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
  [_currentRequest setValue:value forHTTPHeaderField:field];
}

- (void)setParameters:(NSDictionary *)parameters
{
  [self.HTTPparameters setValuesForKeysWithDictionary:parameters];
  [self updateParameters];
}

- (void)setValue:(NSString *)value forParameter:(NSString *)parameter
{
  [self.HTTPparameters setValue:value forKey:parameter];
  [self updateParameters];
}

- (void)setPayload:(id<SPXRestPayloadProtocol>)payload
{
  NSData *data = [payload dataForRequest:self];
  
  if (!data.length) return;
  
  NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
  
  [_currentRequest setHTTPBody:data];
  
  [self setValue:length forHTTPHeaderField:@"Content-Length"];
  [self setValue:[payload contentTypeForRequest:self] forHTTPHeaderField:@"Content-Type"];
}

- (void)setHandlesCookiesAutomatically:(BOOL)shouldHandleCookies
{
  [_currentRequest setHTTPShouldHandleCookies:shouldHandleCookies];
}

#pragma mark - Operation

- (void)start
{
  self.request = _currentRequest;
  [super start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [super connection:connection didFailWithError:error];
  [self finish];
}

- (void)finish;
{
  if (![self isCancelled])
  {
    SPXRestResponse *response = [[SPXRestResponse alloc]
                                 initWithStatus:[(NSHTTPURLResponse *)self.response statusCode]
                                 responseData:self.data
                                 headers:[(NSHTTPURLResponse *)self.response allHeaderFields]
                                 originalRequest:self
                                 responseHandler:_responseHandler];
    
    SPXRestLog(@"%@", [NSString stringWithFormat:@"%@ received | %@ | %@", response.error ? @"Error" : @"Response",
                       [NSString stringWithFormat:@"%@://%@%@", self.URL.scheme, self.URL.host, self.URL.path], response.description]);
    
    SPXRestLogVerbose(@"%@", [NSString stringWithFormat:@"%@ received | %@ | %@", response.error ? @"Error" : @"Response",
                       [NSString stringWithFormat:@"%@://%@%@", self.URL.scheme, self.URL.host, self.URL.path], response.debugDescription]);
    
    if (self.responseCompletionBlock)
      self.responseCompletionBlock(response);
  }
  
  [super finish];
}

@end
