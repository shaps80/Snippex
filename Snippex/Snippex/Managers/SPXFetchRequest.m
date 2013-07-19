/*
   Copyright (c) 2013 net mobile UK. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY net mobile UK `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL net mobile UK OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXFetchRequest.h"

@interface SPXFetchRequest ()
@property (nonatomic, weak) SPXCoreDataStore *store;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, weak) NSManagedObjectContext *context;
@end

@implementation SPXFetchRequest

-(id)initWithStore:(SPXCoreDataStore *)store
           context:(NSManagedObjectContext *)context
        entityName:(NSString *)entityName
{
    self = [super init];

    if (self)
	{
        _store = store;
        _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        _context = context;
	}

    return self;
}

+(instancetype)fetchRequestForStore:(SPXCoreDataStore *)store
                         entityName:(NSString *)entityName
{
    return [[self alloc] initWithStore:store context:store.synchronousContext entityName:entityName];
}

+(instancetype)fetchRequestForStore:(SPXCoreDataStore *)store
                            context:(NSManagedObjectContext *)context
                         entityName:(NSString *)entityName
{
    return [[self alloc] initWithStore:store context:context entityName:entityName];
}

#pragma mark - Multiple objects

-(NSArray *)fetchAllObjects
{
    return [self fetchObjectsWithPredicate:nil sortDescriptors:nil];
}

-(NSArray *)fetchAllObjectsWithSortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetchObjectsWithPredicate:nil sortDescriptors:sortDescriptors];
}

-(NSArray *)fetchObjectsWithPredicate:(NSPredicate *)predicate
{
	return [self fetchObjectsWithPredicate:predicate sortDescriptors:nil];
}

-(NSArray *)fetchObjectsWithPredicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors
{
	[_fetchRequest setPredicate:predicate];
	[_fetchRequest setSortDescriptors:sortDescriptors];

	NSError *error = nil;
	NSArray *objects = [_store.synchronousContext executeFetchRequest:_fetchRequest error:&error];

	if (error)
	{
		NSLog(@"%@ failed: %@", NSStringFromClass([self class]), error);
		return nil;
	}

	return objects;
}

#pragma mark - Single object

-(NSManagedObject *)fetchObjectWithIdentifier:(id)identifier
									   create:(BOOL)create
								 objectState:(SPXStoreObjectState *)objectState
{
    NSString *key = [_store identifierForEntityName:_fetchRequest.entityName];
	NSString *format = [NSString stringWithFormat:@"%@ == \"%@\"", key, identifier];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
	id object = [[self fetchObjectsWithPredicate:predicate sortDescriptors:nil] lastObject];

	if (object)
    {
        if (objectState)
            *objectState = SPXStoreObjectStateFound;
    }
	else
	{
		if (create)
		{
			object = [NSEntityDescription insertNewObjectForEntityForName:_fetchRequest.entityName
												   inManagedObjectContext:_context];

            [object setValue:identifier forKey:key];
            
            if (objectState)
                *objectState = SPXStoreObjectStateAdded;
		}
        // else do nothing
	}

	return object;
}

@end
