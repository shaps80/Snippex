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
#import <CoreData/CoreData.h>

/**
 This class encapsulates a lot of CoreData functionality to allow for easier implementation and management.

 **Note:** There are 2 singleton accessors for this object, however they both return the same singleton object.
 */

@interface SLCoreDataManager : NSObject

#pragma mark -	Shared Instance Initializers
/// @name		Shared Instance Initializers

/**
 @abstract		Default initializer, loads the data model.
 @param			databaseName The name used to store the SQLite database.
 @param			modelName The name used to load the model from the main bundle.
 @discussion		This should only be called ONCE and is not necessary to be called when NOT using this class as a singleton.
 */
+(void)initializeWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName;

/**
 @abstract		Returns a singleton instance.
 @exception		NSInternalInconsistencyException Occurs if +initializeWithDatabaseName:modelName: hasn't been called at least once before
 
 @discussion		It is recommended that you call this in -applicationDidFinishLaunching:withOptions: to ensure it's loaded at launch time.
 */
+(SLCoreDataManager *)sharedInstance;

/**
 @abstract		Designated initializer.
 @exception		NSInvalidArgumentException Occurs if the model cannot be loaded/saved.
 
 @param			databaseName The name to use for the database. This is primarily used to name the file on disk.
 @param			modelName The name to use for the model, this will load from the main bundle a model with this name.
 */
-(id)initWithDatabaseName:(NSString *)databaseName
				modelName:(NSString *)modelName;

#pragma mark -	Getting the Managed Object Context's
/// @name		Getting the Managed Object Context's

/**
 @abstract		The master managed object context.
 @discussion	Should be used for all primary data fetching, such as data in tableViews, etc...
 */
-(NSManagedObjectContext *)masterManagedObjectContext;

/**
 @abstract		The background managed object context.
 @discussion	Should be used for all background data tasks, such as parsing large data sets, before merging them.
 */
-(NSManagedObjectContext *)backgroundManagedObjectContext;

/**
 @abstract		The master managed object context.
 @discussion	Should be used when creating a new model object, before merging it into the master context.
 */
-(NSManagedObjectContext *)newManagedObjectContext;

#pragma mark -	Saving the Managed Object Context's
/// @name		Saving the Managed Object Context's

/// @abstract	Convenience method for saving the master managed object context.
-(void)saveMasterContext;

/// @abstract	Convenience method for saving the background managed object context.
-(void)saveBackgroundContext;

/// @abstract	Convenience method for saving the managed object context used when creating new records.
-(void)saveNewContext;

#pragma mark -	Getting/setting Identifiers
/// @name		Getting/setting Identifiers

/**
 @abstract		Sets the primary key identifier for the specified entity with the given name. This is useful when integrating with a server-based API and a unique identifier needs to be persisted across platforms.
 @param			key The string for the key in the database to use.
 @param			entityName The name of the entity in the database to use.
 @discussion	Each entity can have its own key to be used as its primary key.
 */
+(void)setIdentifierKey:(NSString *)key forEntityName:(NSString *)entityName;

/**
 @abstract		Gets the identifier key for a given entityName.
 @param			entityName The entity name in the database.
 @return		The identifier for this entity.
 */
+(NSString *)identifierKeyForEntityName:(NSString *)entityName;

#pragma mark -	Other Methods
/// @name		Other Methods

/// @abstract	Returns the applications shared documents directory.
-(NSURL *)applicationDocumentsDirectory;

/// @abstract	The managed object model.
-(NSManagedObjectModel *)managedObjectModel;

/// @abstract	The persistent store coordinator.
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end