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

#import "NSManagedObjectContext+SLAdditions.h"
#import "SLCoreDataManager.h"

@implementation NSManagedObjectContext (SLAdditions)

// default entry point - all methods should call this one!
-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors
							predicate:(NSPredicate *)predicate
								limit:(NSInteger)limit
{
	NSEntityDescription *entity = [NSEntityDescription
								   entityForName:entityName inManagedObjectContext:self];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    [request setEntity:entity];
	[request setSortDescriptors:sortDescriptors];
    [request setPredicate:predicate];

	if (limit)
		[request setFetchLimit:limit];

    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];

    if (error != nil)
        [NSException raise:NSGenericException format:@"%@", [error description]];

    return results;
}

// helper method to create new object
-(id)objectWithIdentifier:(id)identifier forEntityName:(NSString *)entityName
{
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
	[object setValue:identifier forKey:[SLCoreDataManager identifierKeyForEntityName:entityName]];
	return object;
}

#pragma mark - Multiple objects

-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetchObjectsForEntityName:entityName
						   sortDescriptors:sortDescriptors
								 predicate:nil
									 limit:0];
}

-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate
{
	return [self fetchObjectsForEntityName:entityName
						   sortDescriptors:nil
								 predicate:predicate
									 limit:0];
}

-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors
							predicate:(NSPredicate *)predicate
{
	return [self fetchObjectsForEntityName:entityName
						   sortDescriptors:sortDescriptors
								 predicate:predicate
									 limit:0];
}

#pragma mark - Single Object

-(id)fetchObjectWithIdentifier:(id)identifier
			   sortDescriptors:(NSArray *)sortDescriptors
					 predicate:(NSPredicate *)predicate
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate
{
	id object = [[self fetchObjectsForEntityName:entityName
								 sortDescriptors:sortDescriptors
									   predicate:predicate
										   limit:1] lastObject];
	
	if (!object && autoCreate)
		object = [self objectWithIdentifier:identifier
							  forEntityName:entityName];

	return object;
}

-(id)fetchObjectWithIdentifier:(id)identifier
					 predicate:(NSPredicate *)predicate
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate
{
	NSCompoundPredicate *compoundPredicate =
	[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[predicate,
	[NSPredicate predicateWithFormat:@"%@ == \"%@\"", [SLCoreDataManager identifierKeyForEntityName:entityName], identifier]]];
	
	return [self fetchObjectWithIdentifier:identifier
						   sortDescriptors:nil
								 predicate:compoundPredicate
								entityName:entityName
								autoCreate:autoCreate];
}

-(id)fetchObjectWithIdentifier:(id)identifier
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate
{
	NSString *format = [NSString stringWithFormat:@"%@ == \"%@\"",
						[SLCoreDataManager identifierKeyForEntityName:entityName], identifier];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
	
	return [self fetchObjectWithIdentifier:identifier
						   sortDescriptors:nil
								 predicate:predicate
								entityName:entityName
								autoCreate:autoCreate];
}

@end