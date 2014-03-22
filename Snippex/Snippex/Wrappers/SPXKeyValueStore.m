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

#import <Security/Security.h>
#import "SPXKeyValueStore.h"

#pragma mark - C Setters

void storeSetObject(id <SPXKeyValueStoreProtocol>store, NSString *key, id value)
{
  [store setObject:value forKey:key];
}

void storeSetBool(id <SPXKeyValueStoreProtocol>store, NSString *key, BOOL value)
{
  [store setBool:value forKey:key];
}

void storeSetString(id <SPXKeyValueStoreProtocol>store, NSString *key, NSString *value)
{
  [store setString:value forKey:key];
}

void storeSetDoule(id <SPXKeyValueStoreProtocol>store, NSString *key, double value)
{
  [store setDouble:value forKey:key];
}

void storeSetInteger(id <SPXKeyValueStoreProtocol>store, NSString *key, NSInteger value)
{
  [store setInteger:value forKey:key];
}

void storeSetFloat(id <SPXKeyValueStoreProtocol>store, NSString *key, CGFloat value)
{
  [store setFloat:value forKey:key];
}

void storeSetDate(id <SPXKeyValueStoreProtocol>store, NSString *key, NSDate *value)
{
  [store setDate:value forKey:key];
}

void storeSetData(id <SPXKeyValueStoreProtocol>store, NSString *key, NSData *value)
{
  [store setData:value forKey:key];
}

void storeSetSet(id <SPXKeyValueStoreProtocol>store, NSString *key, NSSet *value)
{
  [store setSet:value forKey:key];
}

void storeSetArray(id <SPXKeyValueStoreProtocol>store, NSString *key, NSArray *value)
{
  [store setArray:value forKey:key];
}

void storeSetDictionary(id <SPXKeyValueStoreProtocol>store, NSString *key, NSDictionary *value)
{
  [store setDictionary:value forKey:key];
}

#pragma mark - C Getters

id storeGetObject(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store objectForKey:key];
}

BOOL storeGetBool(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store boolForKey:key];
}

NSString* storeGetString(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store stringForKey:key];
}

double storeGetDouble(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store doubleForKey:key];
}

NSInteger storeGetInteger(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store integerForKey:key];
}

CGFloat storeGetFloat(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store floatForKey:key];
}

NSDate* storeGetDate(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store dateForKey:key];
}

NSData* storeGetData(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store dataForKey:key];
}

NSSet* storeGetSet(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store setForKey:key];
}

NSArray* storeGetArray(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store arrayForKey:key];
}

NSDictionary* storeGetDictionary(id <SPXKeyValueStoreProtocol>store, NSString *key)
{
  return [store dictionaryForKey:key];
}

BOOL storeSync(id <SPXKeyValueStoreProtocol>store)
{
  return [store synchronize];
}

#pragma mark - SPXStoreKeychain

@interface SPXKeychain : NSObject <SPXKeyValueStoreProtocol>
+(instancetype)sharedKeychain;
@end


@implementation SPXKeyValueStore

#pragma mark - Lifecycle

+ (instancetype)keychain
{
	return (id <SPXKeyValueStoreProtocol>)[SPXKeychain sharedKeychain];
}

+ (instancetype)iCloud
{
	return (id <SPXKeyValueStoreProtocol>)[NSUbiquitousKeyValueStore defaultStore];
}

+ (instancetype)userDefaults
{
	return (id <SPXKeyValueStoreProtocol>)[NSUserDefaults standardUserDefaults];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    NSAssert(NO, @"You should not implement this class directly!");
}

- (id)objectForKey:(NSString *)key
{
    NSAssert(NO, @"You should not implement this class directly!");
    return nil;
}

- (void)removeObjectForKey:(NSString *)key
{
    NSAssert(NO, @"You should not implement this class directly!");
}

@end

#pragma mark - Keychain Wrapper

#define DEFAULT_ACCESSIBILITY kSecAttrAccessibleWhenUnlocked

#if __has_feature(objc_arc)
#define SPX_ID __bridge id
#define SPX_DICTIONARY_REF __bridge CFDictionaryRef
#else
#define SPX_ID id
#define SPX_DICTIONARY_REF CFDictionaryRef
#endif

static NSString *SPXBundleId = nil;


@implementation SPXKeychain

+(void)initialize
{
	SPXBundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

+(instancetype)sharedKeychain
{
	static SPXKeychain *_sharedKeychain = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedKeychain = [[self alloc] init];
	});

	return _sharedKeychain;
}

- (NSString *)keyByAppendingBundleIdToKey:(NSString *)key
{
    return [SPXBundleId stringByAppendingFormat:@".%@", key];
}

- (NSMutableDictionary *)service
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:(SPX_ID)kSecClassGenericPassword forKey:(SPX_ID)kSecClass];
    return dict;
}

- (NSMutableDictionary *)query
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];

    [query setObject:(SPX_ID)kSecClassGenericPassword forKey:(SPX_ID)kSecClass];
    [query setObject:(SPX_ID)kCFBooleanTrue forKey:(SPX_ID) kSecReturnData];

    return query;
}

#pragma mark - Removals

- (void)removeObjectForKey:(NSString *)key
{
	[self setObject:nil forKey:key];
}

#pragma mark - Setters

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key
{
	[self setObject:object forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setFloat:(CGFloat)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
	[self setObject:value forKey:key];
}

- (void)setDate:(NSDate *)date forKey:(NSString *)key
{
	[self setObject:date forKey:key];
}

- (void)setData:(NSData *)data forKey:(NSString *)key
{
	[self setObject:data forKey:key];
}

- (void)setSet:(NSSet *)set forKey:(NSString *)key
{
	[self setObject:set forKey:key];
}

- (void)setArray:(NSArray *)array forKey:(NSString *)key
{
	[self setObject:array forKey:key];
}

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
	[self setObject:dictionary forKey:key];
}

#pragma mark - Getters

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (BOOL)boolForKey:(NSString *)key
{
	return [[self objectForKey:key] boolValue];
}

- (double)doubleForKey:(NSString *)key
{
	return [[self objectForKey:key] doubleValue];
}

- (CGFloat)floatForKey:(NSString *)key
{
	return [[self objectForKey:key] floatValue];
}

- (NSInteger)integerForKey:(NSString *)key
{
	return [[self objectForKey:key] integerValue];
}

- (NSString *)stringForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (NSDate *)dateForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (NSData *)dataForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (NSSet *)setForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
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

- (NSString *)objectForKey:(NSString *)key
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

- (BOOL)synchronize
{
	return YES;
}

- (NSDictionary *)dictionaryRepresentation
{
	return nil;
}

@end
