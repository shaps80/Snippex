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

#import <Foundation/Foundation.h>

@protocol SPXKeyValueStoreProtocol <NSObject>

@required

// storage for any object type, passing a nil object, will remove its key/value from the store
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@optional

// keyed subscripting
- (void)setObject:(id)object forKeyedSubscript:(id)key;
- (id)objectForKeyedSubscript:(id)key;

// convenience setters
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(CGFloat)value forKey:(NSString *)key;
- (void)setDate:(NSDate *)value forKey:(NSString *)key;
- (void)setData:(NSData *)value forKey:(NSString *)key;
- (void)setSet:(NSSet *)value forKey:(NSString *)key;
- (void)setArray:(NSArray *)value forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)value forKey:(NSString *)key;

// convenience getters
- (BOOL)boolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (CGFloat)floatForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSSet *)setForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

// this ALWAYS returns nil for the keychain since the keychain doesn't support this
- (NSDictionary *)dictionaryRepresentation;

// commit any changes to the store, this MUST be called for userDefaults type, but in your implementation is useful for knowing when to commit changes.
- (BOOL)synchronize;

@end

/**
 SPXStore consolidates all your key/value storage needs into a single class allowing easy storage and recovery of key/value pairs across 3 store types.
 NSUserDefaults, iCloud and the Keychain. It also supports additional features, such as on-the-fly encryption/decryption of values where required. 
 It supports NSNull and when the object being passed is nil, NSNull is stored in its place, so that when you attempt to recover the value, nil is returned.
 */

@interface SPXKeyValueStore : NSObject <SPXKeyValueStoreProtocol>

+ (id <SPXKeyValueStoreProtocol>)keychain;
+ (id <SPXKeyValueStoreProtocol>)userDefaults;
+ (id <SPXKeyValueStoreProtocol>)iCloud;

@end
