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

#ifndef _SPXSTORE_H
#define _SPXSTORE_H

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+SPXStoreAdditions.h"

#ifndef _COREDATADEFINES_H
#warning "CoreData framework not found in project, or not included in precompiled header."
#endif

@interface SPXStore : NSObject

+ (instancetype)storeNamed:(NSString *)name;

+ (instancetype)addStoreNamed:(NSString *)name filename:(NSString *)filename;
+ (instancetype)addStoreNamed:(NSString *)name filename:(NSString *)filename seedPath:(NSString *)seedPath;

+ (void)setDefaultStoreName:(NSString *)name filename:(NSString *)filename;
+ (void)setDefaultStoreName:(NSString *)name filename:(NSString *)filename seedPath:(NSString *)seedPath;

- (NSManagedObjectContext *)mainContext;
- (NSManagedObjectContext *)privateContext;
- (NSManagedObjectContext *)newContextForType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (void)setKey:(NSString *)key forEntityNamed:(NSString *)name;
- (NSString *)keyForEntityNamed:(NSString *)name;

// Convenience methods

/// @return     Returns a singleton instance of SPXStore
+ (instancetype)default;

/// @return     Returns the main NSManagedObjectContext to be used in the UI, using the default SPXStore
+ (NSManagedObjectContext *)mainContext;

/// @return     Returns the priavate NSManagedObjectContext to be used in updates, using the default SPXStore
+ (NSManagedObjectContext *)privateContext;

- (NSURL *)URL;

+ (NSError *)saveContext:(NSManagedObjectContext *)context;

+ (void)logVerbose:(NSString *)message;

+ (void)setLoggingType:(SPXStoreLoggingType)type;

@end

#endif