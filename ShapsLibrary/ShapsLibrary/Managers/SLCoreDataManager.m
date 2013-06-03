//
//  PPCoreDataManager.m
//  RESTing
//
//  Created by Shaps Mohsenin on 16/10/12.
//  Copyright (c) 2012 Shaps. All rights reserved.
//

#import "SLCoreDataManager.h"

#define KEY_COREDATA_MODEL_VERSION	@"CoreDataModelVersion"

NSString *SLDataInvalidModelException =		@"SLDataInvalidModelException";

static const NSString *kDatabaseName = nil;
static const NSString *kModelName = nil;
static const NSMutableDictionary *entityIdentifiers = nil;

@interface SLCoreDataManager ()

@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, copy) NSString *modelName;

@property (strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

int ddLogLevel;

@implementation SLCoreDataManager

#pragma mark - Lifecycle

+(BOOL)validModelName:(NSString *)modelName
{
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
	return (modelURL != nil);
}

+(void)initializeWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName
{
	[super initialize];

	kDatabaseName = databaseName;
	kModelName = modelName;
}

+(SLCoreDataManager *)sharedInstance
{
	static SLCoreDataManager *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^
	{
		if (!(kDatabaseName.length && kModelName.length))
		{
			NSException *exception = [NSException exceptionWithName:NSGenericException
															 reason:@"Have you forgotten to call +initializeWithDatabaseName:modelName:"
														   userInfo:@{NSLocalizedDescriptionKey :
									  @"You should call +initializeWithDatabaseName:modelName: just ONCE before using this singleton class."}];
			[exception raise];
		}
		else
			_sharedInstance = [[self alloc] initWithDatabaseName:[kDatabaseName copy] modelName:[kModelName copy]];
	});

	return _sharedInstance;
}

-(id)init
{
	NSAssert(NO, @"Please use -initWithDatabaseName:modelName:");
	return nil;
}

-(id)initWithDatabaseName:(NSString *)databaseName modelName:(NSString *)modelName
{
	self = [super init];

	if (self)
	{
		if (!(databaseName.length && modelName.length))
		{
			[NSException raise:NSInvalidArgumentException format:@"You have not provided a valid database and/or model name."];
			return nil;
		}
		else if (![SLCoreDataManager validModelName:modelName])
		{
			NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
															 reason:@"Could not locate a model with that name."
														   userInfo:nil];
			[exception raise];
		}
		else
		{
			_databaseName = databaseName;
			_modelName = modelName;

			[self removeOldModelIfRequired];
		}
	}

	return self;
}

+(void)setIdentifierKey:(NSString *)key forEntityName:(NSString *)entityName
{
	if (!entityIdentifiers)
		entityIdentifiers = [[NSMutableDictionary alloc] init];

	[entityIdentifiers setObject:key forKey:entityName];
}

+(NSString *)identifierKeyForEntityName:(NSString *)entityName
{
	return [entityIdentifiers objectForKey:entityName];
}

-(void)removeOldModelIfRequired
{
	NSManagedObjectModel *model = [self managedObjectModel];
	NSArray *versionIdentifiers = [model.versionIdentifiers allObjects];

	if (![versionIdentifiers count])
	{
		NSLog(@"Error: No model found!");
		return;
	}

	NSString *currentVersionIdentifier = [[model.versionIdentifiers allObjects] objectAtIndex:0];

	if ([[[NSUserDefaults standardUserDefaults] stringForKey:KEY_COREDATA_MODEL_VERSION] isEqualToString:currentVersionIdentifier])
		return;

	NSString *path = [[self applicationDocumentsDirectory].path
					  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _databaseName]];

	NSError *error=nil;
	[[NSUserDefaults standardUserDefaults] setValue:currentVersionIdentifier forKey:KEY_COREDATA_MODEL_VERSION];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSURL *storeUrl = [NSURL fileURLWithPath:path];

	if ([[NSFileManager defaultManager] fileExistsAtPath:storeUrl.path])
	{
		if ([[NSFileManager defaultManager] removeItemAtURL:storeUrl error:&error])
		{
			NSLog(@"Data model was updated successfully.");
		}
		else
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

-(NSManagedObjectContext *)masterManagedObjectContext
{
    if (_masterManagedObjectContext != nil)
        return _masterManagedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator)
	{
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext performBlockAndWait:^
		{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];

    }
    return _masterManagedObjectContext;
}

-(NSManagedObjectContext *)backgroundManagedObjectContext
{
    if (_backgroundManagedObjectContext)
        return _backgroundManagedObjectContext;

    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil)
	{
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^
		{
            [_backgroundManagedObjectContext setParentContext:masterContext];
        }];
    }

    return _backgroundManagedObjectContext;
}

- (NSManagedObjectContext *)newManagedObjectContext
{
    NSManagedObjectContext *newContext = nil;
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];

    if (masterContext)
	{
        newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [newContext performBlockAndWait:^
		{
            [newContext setParentContext:masterContext];
        }];
    }

    return newContext;
}

-(void)saveMasterContext
{
    [self.masterManagedObjectContext performBlockAndWait:^
	{
        NSError *error = nil;
        BOOL saved = [self.masterManagedObjectContext save:&error];

        if (!saved)
		{
            // do some real error handling
            NSLog(@"Could not save master context due to %@", error);
        }
    }];
}

-(void)saveBackgroundContext
{
    [self.backgroundManagedObjectContext performBlockAndWait:^
	{
        NSError *error = nil;
        BOOL saved = [self.backgroundManagedObjectContext save:&error];

        if (!saved)
		{
            // do some real error handling
            NSLog(@"Could not save background context due to %@", error);
        }
    }];
}

-(void)saveNewContext
{
    [self.newManagedObjectContext performBlockAndWait:^
	 {
		 NSError *error = nil;
		 BOOL saved = [self.newManagedObjectContext save:&error];

		 if (!saved)
		 {
			 // do some real error handling
			 NSLog(@"Could not save background context due to %@", error);
		 }
	 }];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _databaseName]];
	
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