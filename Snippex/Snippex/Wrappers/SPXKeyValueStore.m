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

#pragma mark - SPXStoreProtocol

// Defines methods that a store MUST implement
@protocol SPXStoreProtocol <NSObject>
-(void)setObject:(id)object forKey:(NSString *)key;
-(id)objectForKey:(NSString *)forKey;
-(BOOL)synchronize;
-(NSDictionary *)dictionaryRepresentation;
@end

#pragma mark - SPXStoreKeychain

@interface SPXStoreKeychain : NSObject <SPXStoreProtocol>
+(SPXStoreKeychain *)sharedKeychain;
@end

#pragma mark - SPXStore

@interface SPXKeyValueStore ()
@property (nonatomic, strong) id store;
@end


@implementation SPXKeyValueStore

#pragma mark - Lifecycle

-(id)initWithStoreType:(SPXStoreType)type
{
	self = [super init];

	if (self)
	{
		if (type == SPXStoreTypeUserDefaults)
			_store = [self userDefaults];
		else if (type == SPXStoreTypeiCloud)
			_store = [self iCloud];
		else if (type == SPXStoreTypeKeychain)
			_store = [self keychain];
		else
			return nil;
	}

	return self;
}

-(SPXStoreKeychain *)keychain
{
	return [SPXStoreKeychain sharedKeychain];
}

-(NSUbiquitousKeyValueStore *)iCloud
{
	return [NSUbiquitousKeyValueStore defaultStore];
}

-(NSUserDefaults *)userDefaults
{
	return [NSUserDefaults standardUserDefaults];
}

+(instancetype)storeForType:(SPXStoreType)type
{
	return [[SPXKeyValueStore alloc] initWithStoreType:type];
}

-(BOOL)synchronize
{
	return [_store synchronize];
}

-(NSDictionary *)dictionaryRepresentation
{
	return [_store dictionaryRepresentation];
}

#pragma mark - Primary set and get

// all setters should come here...
-(void)setObject:(id)object forKey:(NSString *)key encrypt:(BOOL)encrypt
{
	[_store setObject:object forKey:key];

	NSString *storeKey = key;
	id storeObject = object;

	// perform encryption here
	if (encrypt)
	{

	}

	[_store setObject:storeObject forKey:storeKey];
}

// all getters should come here...
-(id)objectForKey:(NSString *)key encrypted:(BOOL)encrypted
{
	NSString *storeKey = key;
	id storeObject = [_store objectForKey:storeKey];

	// perform decryption here
	if (encrypted)
	{

	}

	return storeObject;
}

-(void)removeObjectForKey:(NSString *)key
{
	[self setObject:nil forKey:key encrypt:NO];
}

#pragma mark - Setters

-(void)setBool:(BOOL)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key encrypt:NO];
}

-(void)setObject:(id)object forKeyedSubscript:(id)key
{
	[self setObject:object forKey:key encrypt:NO];
}

-(void)setObject:(id)object forKey:(NSString *)key
{
	[self setObject:object forKey:key encrypt:NO];
}

-(void)setDouble:(double)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key encrypt:NO];
}

-(void)setFloat:(CGFloat)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key encrypt:NO];
}

-(void)setInteger:(NSInteger)value forKey:(NSString *)key
{
	[self setObject:@(value) forKey:key encrypt:NO];
}

-(void)setString:(NSString *)value forKey:(NSString *)key
{
	[self setObject:value forKey:key encrypt:NO];
}

-(void)setDate:(NSDate *)date forKey:(NSString *)key
{
	[self setObject:date forKey:key encrypt:NO];
}

-(void)setData:(NSData *)data forKey:(NSString *)key
{
	[self setObject:data forKey:key encrypt:NO];
}

-(void)setSet:(NSSet *)set forKey:(NSString *)key
{
	[self setObject:set forKey:key encrypt:NO];
}

-(void)setArray:(NSArray *)array forKey:(NSString *)key
{
	[self setObject:array forKey:key encrypt:NO];
}

-(void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
	[self setObject:dictionary forKey:key encrypt:NO];
}

#pragma mark - Getters

-(id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key encrypted:NO];
}

-(BOOL)boolForKey:(NSString *)key
{
	return [[self objectForKey:key encrypted:NO] boolValue];
}

-(id)objectForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(double)doubleForKey:(NSString *)key
{
	return [[self objectForKey:key encrypted:NO] doubleValue];
}

-(CGFloat)floatForKey:(NSString *)key
{
	return [[self objectForKey:key encrypted:NO] floatValue];
}

-(NSInteger)integerForKey:(NSString *)key
{
	return [[self objectForKey:key encrypted:NO] integerValue];
}

-(NSString *)stringForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(NSDate *)dateForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(NSData *)dataForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(NSSet *)setForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(NSArray *)arrayForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
}

-(NSDictionary *)dictionaryForKey:(NSString *)key
{
	return [self objectForKey:key encrypted:NO];
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


@implementation SPXStoreKeychain

+(void)initialize
{
	SPXBundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

+(SPXStoreKeychain *)sharedKeychain
{
	static SPXStoreKeychain *_sharedKeychain = nil;
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
