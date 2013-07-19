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

#import "SPXKeychainStore.h"

#define DEFAULT_ACCESSIBILITY kSecAttrAccessibleWhenUnlocked

#if __has_feature(objc_arc)
#define SPX_ID __bridge id
#define SPX_DICTIONARY_REF __bridge CFDictionaryRef
#else
#define SPX_ID id
#define SPX_DICTIONARY_REF CFDictionaryRef
#endif

static NSString *SPXBundleId = nil;


@implementation SPXKeychainStore

+(void)initialize
{
	SPXBundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

+(instancetype)sharedKeychain
{
	static SPXKeychainStore *_sharedKeychain = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedKeychain = [[self alloc] init];
	});

	return _sharedKeychain;
}

-(NSString *)keyByAppendingBundleIdToKey:(NSString *)key
{
    return [SPXBundleId stringByAppendingFormat:@".%@", key];
}

-(NSMutableDictionary *)service
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:(SPX_ID)kSecClassGenericPassword forKey:(SPX_ID)kSecClass];
    return dict;
}

-(NSMutableDictionary *)query
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];

    [query setObject:(SPX_ID)kSecClassGenericPassword forKey:(SPX_ID)kSecClass];
    [query setObject:(SPX_ID)kCFBooleanTrue forKey:(SPX_ID) kSecReturnData];

    return query;
}

-(void)setObject:(id)object forKey:(NSString *)key
{
	if (!key.length)
	{
		NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
														 reason:@"The key must contain a string with a length greater than 0"
													   userInfo:nil];
		[exception raise];
	}

	NSString *storeKey = [self keyByAppendingBundleIdToKey:key];

    // If the object is nil, delete the item
    if (!object)
	{
        NSMutableDictionary *query = [self query];
        [query setObject:storeKey forKey:(SPX_ID)kSecAttrService];
        SecItemDelete((SPX_DICTIONARY_REF)query);
		return;
    }

	OSStatus status;
    NSMutableDictionary *dict = [self service];

    [dict setObject:storeKey forKey:(SPX_ID)kSecAttrService];

#if TARGET_OS_IPHONE
    [dict setObject:(SPX_ID)(DEFAULT_ACCESSIBILITY) forKey:(SPX_ID)kSecAttrAccessible];
#endif

	id storeObject =
#if TARGET_OS_IPHONE
	[NSKeyedArchiver
#else
	 [NSArchiver
#endif
      archivedDataWithRootObject:object];

     [dict setObject:storeObject forKey:(SPX_ID)kSecValueData];

     status = SecItemAdd((SPX_DICTIONARY_REF) dict, NULL);

     if (status == errSecDuplicateItem)
     {
         NSMutableDictionary *query = [self query];

         [query setObject:storeKey forKey:(SPX_ID)kSecAttrService];
         status = SecItemDelete((SPX_DICTIONARY_REF)query);

         if (status == errSecSuccess)
             SecItemAdd((SPX_DICTIONARY_REF) dict, NULL);
     }
 }

-(NSString *)objectForKey:(NSString *)key
{
    NSString *storeKey = [self keyByAppendingBundleIdToKey:key];

    NSMutableDictionary *query = [self query];
    [query setObject:storeKey forKey:(SPX_ID)kSecAttrService];

    CFDataRef data = nil;
    SecItemCopyMatching((SPX_DICTIONARY_REF)query, (CFTypeRef *)&data);

    if (!data)
        return nil;

    id storeObject =
#if TARGET_OS_IPHONE
    [NSKeyedUnarchiver
#else
     [NSUnarchiver
#endif
      unarchiveObjectWithData:
#if __has_feature(objc_arc)
      (__bridge_transfer NSData *)data
#else
      (NSData *)data
#endif
      ];
     
#if !__has_feature(objc_arc)
     CFRelease(data);
#endif
     
     return storeObject;
 }
     
-(BOOL)synchronize
{
    return YES;
}

-(NSDictionary *)dictionaryRepresentation
{
    return nil;
}

@end
