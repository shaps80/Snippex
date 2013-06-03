/*
 Copyright (c) 2013 Shaps. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Shaps `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <CoreData/CoreData.h>

/**
 An NSManagedObjectContext category that encapsulates some common fetch requests.
 */

@interface NSManagedObjectContext (SLAdditions)

/**
 @abstract		Returns all objects from the entity, sorted using the specified sort descriptors.
 @param			entityName The name of the entity to fetch.
 @param			sortDescriptors The sort descriptors to apply to this fetch request.
 @return		An array of NSManagedObject instances, nil if the results are empty.
 */
-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors;

/**
 @abstract		Returns all objects from the entity, filtered by the specified predicate.
 @param			entityName The name of the entity to fetch.
 @param			predicate The predicate to apply to this fetch request.
 @return		An array of NSManagedObject instances, nil if the results are empty.
 */
-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate;

/**
 @abstract		Returns all objects from the entity, sorted using the specified sort descriptors and filtered by the given predicate.
 @param			entityName The name of the entity to fetch.
 @param			sortDescriptors The sort descriptors to apply to this fetch request.
 @param			predicate The predicate to apply to this fetch request.
 @return		An array of NSManagedObject instances, nil if the results are empty.
 */
-(NSArray *)fetchObjectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors
							predicate:(NSPredicate *)predicate;

/**
 @abstract		Returns an NSManagedObject instance from the specified entity with the given identifier.
 @param			identifier The identifier of the object.
 @param			entityName The name of the entity to fetch.
 @param			autoCreate If yes, when the object is _not_ found, it is automatically created.
 @return		An NSManagedObject instance if found, nil otherwise.
 */
-(id)fetchObjectWithIdentifier:(id)identifier
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate;

/**
 @abstract		Returns an NSManagedObject instance from the specified entity with the given identifier, filtered by predicate.
 @param			identifier The identifier of the object.
 @param			predicate The predicate to apply to this fetch request.
 @param			entityName The name of the entity to fetch.
 @param			autoCreate If yes, when the object is _not_ found, it is automatically created.
 @return		An NSManagedObject instance if found, nil otherwise.
 */
-(id)fetchObjectWithIdentifier:(id)identifier
					 predicate:(NSPredicate *)predicate
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate;

/**
 @abstract		Returns an NSManagedObject instance from the specified entity with the given identifier, sorted by sortDescriptors and filtered by predicate.
 @param			identifier The identifier of the object.
 @param			sortDescriptors The sort descriptors to apply to this fetch request.
 @param			predicate The predicate to apply to this fetch request.
 @param			entityName The name of the entity to fetch.
 @param			autoCreate If yes, when the object is _not_ found, it is automatically created.
 @return		An NSManagedObject instance if found, nil otherwise.
 */
-(id)fetchObjectWithIdentifier:(id)identifier
			   sortDescriptors:(NSArray *)sortDescriptors
					 predicate:(NSPredicate *)predicate
					entityName:(NSString *)entityName
					autoCreate:(BOOL)autoCreate;

@end