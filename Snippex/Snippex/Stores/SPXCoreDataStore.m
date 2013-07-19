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

#import "SPXCoreDataStore.h"

static NSString * SPXCoreDataStoreVersionKey = nil;

@interface SPXCoreDataStore ()

@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSMutableDictionary *entityIdentifiers;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSURL *)applicationDocumentsDirectory;

@end

@implementation SPXCoreDataStore

@synthesize synchronousContext = _synchronousContext;
@synthesize asynchronousContext = _asynchronousContext;
@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - Lifecycle

+(instancetype)storeWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName
{
	if (!(databaseName.length && modelName.length))
	{
		NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
														 reason:@"Invalid database or model name specified"
													   userInfo:nil];
		[exception raise];
	}

	return [[SPXCoreDataStore alloc] initWithDatabaseName:databaseName modelName:modelName];
}

- (id)init
{
	NSAssert(NO, @"You must use the designated initializer -initWithDatabaseName:modelName:");
	return nil;
}

-(id)initWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName
{
	self = [super init];

	if (self)
	{
        SPXCoreDataStoreVersionKey = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingPathExtension:@"ModelVersion"];

		_databaseName = databaseName;
		_modelName = modelName;

		[self initializeModel];
	}

	return self;
}

-(NSURL *)databaseURL
{
    return [NSURL fileURLWithPathComponents:@[[self applicationDocumentsDirectory].path,
                                              [_databaseName stringByAppendingPathExtension:@"sqlite"]]];
}

#pragma mark - Saving

-(BOOL)saveSynchronousContext
{
	return [self saveContext:_synchronousContext error:nil];
}

-(BOOL)saveAsynchronousContext
{
	return [self saveContext:_asynchronousContext error:nil];
}

-(BOOL)saveContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error
{
    return [context save:error];
}

#pragma mark - Entity Identifiers

-(NSMutableDictionary *)entityIdentifiers
{
	return _entityIdentifiers ?: (_entityIdentifiers = [[NSMutableDictionary alloc] init]);
}

-(void)setIdentifierKey:(NSString *)identifier forEntityName:(NSString *)entitiyName
{
	[self.entityIdentifiers setObject:identifier forKey:entitiyName];
}

-(NSString *)identifierForEntityName:(NSString *)entityName
{
	NSString *identifier = [_entityIdentifiers objectForKey:entityName];
	return identifier ?: @"identifier";
}

#pragma mark - Model

-(void)initializeModel
{
    _managedObjectModel = [self managedObjectModel];
	NSArray *versionIdentifiers = [_managedObjectModel.versionIdentifiers allObjects];

	if (![versionIdentifiers count])
	{
		NSLog(@"Error: No model found!");
		return;
	}

	NSString *currentVersionIdentifier = [[_managedObjectModel.versionIdentifiers allObjects] objectAtIndex:0];

	if ([[[NSUserDefaults standardUserDefaults] stringForKey:SPXCoreDataStoreVersionKey] isEqualToString:currentVersionIdentifier])
		return;

	NSString *path = [[self applicationDocumentsDirectory].path
					  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _databaseName]];

	NSError *error=nil;
	[[NSUserDefaults standardUserDefaults] setValue:currentVersionIdentifier forKey:SPXCoreDataStoreVersionKey];
	[[NSUserDefaults standardUserDefaults] synchronize];

	NSURL *storeUrl = [NSURL fileURLWithPath:path];

	if ([[NSFileManager defaultManager] fileExistsAtPath:storeUrl.path])
	{
		if ([[NSFileManager defaultManager] removeItemAtURL:storeUrl error:&error])
			NSLog(@"Data model was updated successfully.");
		else
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

-(NSManagedObjectContext *)synchronousContext
{
    if (_synchronousContext != nil)
        return _synchronousContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator)
	{
        _synchronousContext = [[NSManagedObjectContext alloc]
                               initWithConcurrencyType:NSPrivateQueueConcurrencyType];

        [_synchronousContext performBlockAndWait:^
         {
			 [_synchronousContext setPersistentStoreCoordinator:coordinator];
         }];

    }

    return _synchronousContext;
}

-(NSManagedObjectContext *)asynchronousContext
{
    if (_asynchronousContext)
        return _asynchronousContext;

    NSManagedObjectContext *masterContext = [self synchronousContext];
    if (masterContext != nil)
	{
        _asynchronousContext = [[NSManagedObjectContext alloc]
                                initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_asynchronousContext performBlockAndWait:^
		 {
			 [_asynchronousContext setParentContext:masterContext];
		 }];
    }

    return _asynchronousContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;

	NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory]
					   URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _databaseName]];

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
	{
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}

#pragma mark - File management

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end