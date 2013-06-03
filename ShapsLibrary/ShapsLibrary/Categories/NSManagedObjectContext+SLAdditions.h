//
//  NSManagedObjectContext+CLAdditions.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

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