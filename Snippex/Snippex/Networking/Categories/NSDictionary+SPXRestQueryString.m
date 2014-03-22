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

#import "NSDictionary+SPXRestQueryString.h"
#import "NSString+SPXRestQueryString.h"

@implementation NSDictionary (SPXRestQueryString)

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)string
{
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  NSArray* pairs = [string componentsSeparatedByString:@"&"];
  
  for (NSString* kvp in pairs)
  {
    if ([kvp length] == 0)
      continue;
    
    NSRange pos = [kvp rangeOfString:@"="];
    NSString *key;
    NSString *val;
    
    if (pos.location == NSNotFound)
    {
      key = [kvp removePercentEscapesFromQuery];
      val = @"";
    }
    else
    {
      key = [[kvp substringToIndex:pos.location] removePercentEscapesFromQuery];
      val = [[kvp substringFromIndex:pos.location + pos.length] removePercentEscapesFromQuery];
    }
    
    if (!key || !val)
      continue; // I'm sure this will bite my arse one day
    
    [result setObject:val forKey:key];
  }
  
  return result;
}

- (NSString *)stringWithFormEncodedComponents
{
  NSMutableArray *arguments = [NSMutableArray array];
  
  for (NSString *key in self)
    [self formEncodeObject:[self objectForKey:key] usingKey:key subKey:nil intoArray:arguments];
  
  return [arguments componentsJoinedByString:@"&"];
}

- (void)formEncodeObject:(id)object usingKey:(NSString *)key subKey:(NSString *)subKey intoArray:(NSMutableArray *)array
{
  NSString *objectKey = nil;
  
  if (subKey)
    objectKey = [NSString stringWithFormat:@"%@[%@]", [key description], [[subKey description] addPercentEscapesForQuery]];
  else
    objectKey = [[key description] addPercentEscapesForQuery];
  
  if ([object respondsToSelector:@selector(addPercentEscapesForQuery)])
    [array addObject:[NSString stringWithFormat:@"%@=%@", objectKey, [object addPercentEscapesForQuery]]];
  else if ([object isKindOfClass:[self class]])
  {
    NSDictionary *dicObject = (NSDictionary *)object;
    for (NSString *nestedKey in object)
      [self formEncodeObject:[dicObject objectForKey:nestedKey] usingKey:objectKey subKey:nestedKey intoArray:array];
  }
  else
    [array addObject:[NSString stringWithFormat:@"%@=%@", objectKey, [[object description] addPercentEscapesForQuery]]];
}


@end
