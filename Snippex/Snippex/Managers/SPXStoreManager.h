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
#import "SPXStoreDefines.h"
#import "SPXCoreDataStore.h"
#import "SPXiCloudStore.h"
#import "SPXDefaultsStore.h"
#import "SPXKeychainStore.h"

/**
 This class provides an interface for managing multiple data stores.
 */
@interface SPXStoreManager : NSObject

/**
 @abstract      Adds the specified store, using the given name as its key
 @param         store The store to add
 @param         name The key to be used for retrieving this store later
 */
+(void)addStore:(SPXCoreDataStore *)store withName:(NSString *)name;

/**
 @abstract      Returns the store associated with the given key
 @param         name The key this store is stored to
 @return        A CDStore instance
 */
+(SPXCoreDataStore *)storeWithName:(NSString *)name;

/**
 @abstract      Merges the source store into the destination store
 @param         sourceStore The source store to merge from
 @param         destinationStore The destination store to merge into
 @param         error If the merge fails this object will contain the error associated with the failure
 @return        YES is successful, NO otherwise
 */
+(BOOL)mergeSourceStore:(SPXCoreDataStore *)sourceStore
   withDestinationStore:(SPXCoreDataStore *)destinationStore
                  error:(out NSError **)error;

@end
