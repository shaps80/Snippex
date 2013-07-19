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

@interface SPXCoreDataStore : NSObject

/// @abstract A Synchronous managedObjectContext associated with this store
@property (strong, nonatomic, readonly) NSManagedObjectContext *synchronousContext;

/// @abstract An Asynchronous managedObjectContext associated with this store
@property (strong, nonatomic, readonly) NSManagedObjectContext *asynchronousContext;

/// @abstract The managedObjectModel associated with this store
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;

/// @abstract The URL where this store is saved on disk
@property (weak, nonatomic, readonly) NSURL *databaseURL;

/**
 @abstract      Initializes a store, loads the specified model and saves the database at the given url
 @param         databaseName The name to use for the database
 @param         modelName The name of the model to load (this must be in your main bundle)
 @return        A CDStore instance with its model loaded an its managedObjectContext set
 */
+(instancetype)storeWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName;

/**
 @abstract      Configures the identifier key for a given entity
 @param         identifier The identifier key for the given entity
 @param         entityName The entityName this identifier key should be configured for
 */
-(void)setIdentifierKey:(NSString *)identifier forEntityName:(NSString *)entitiyName;

/**
 @abstract      Returns the identifier associated with the specified entityName
 @param         entityName The entity to lookup
 @return        An NSString representation of the identifier key for this entity
 */
-(NSString *)identifierForEntityName:(NSString *)entityName;

/**
 @abstract      Saves the synchronous managedObjectContext
 @return        YES if successful, NO otherwise
 */
-(BOOL)saveSynchronousContext;

/**
 @abstract      Saves the asynchronous managedObjectContext
 @return        YES if successful, NO otherwise
 */
-(BOOL)saveAsynchronousContext;

/**
 @abstract      Saves the specified context
 @param         context The context to be saved
 @param         error If the save is unsuccessful this will contain the error associated with this failure
 @return        YES if successful, NO otherwise
 */
-(BOOL)saveContext:(NSManagedObjectContext *)context error:(NSError **)error;

@end
