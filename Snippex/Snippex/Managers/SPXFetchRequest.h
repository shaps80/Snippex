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

#import <CoreData/CoreData.h>
#import "SPXCoreDataStore.h"

/**
 Encapsulates an NSFetchRequest with convenience methods for fetching items from a CDStore
 */
@interface SPXFetchRequest : NSObject

/**
 @abstract      Creates a fetch request for the specified store and entity name
 @param         store The store associated with this fetch request
 @param         entityName the name of the entity this request will be performed on
 @return        An instance of SPXFetchRequest with its managedObjectContext and entity configured
 */
+(instancetype)fetchRequestForStore:(SPXCoreDataStore *)store
                         entityName:(NSString *)entityName;

/**
 @abstract      Creates a fetch request for the specified store and entity name
 @param         store The store associated with this fetch request
 @param         context The managedObjectContext associated with this store
 @param         entityName the name of the entity this request will be performed on
 @return        An instance of SPXFetchRequest with its managedObjectContext and entity configured
 */
+(instancetype)fetchRequestForStore:(SPXCoreDataStore *)store
                            context:(NSManagedObjectContext *)context
                         entityName:(NSString *)entityName;

/**
 @abstract      Fetches all objects associated with the predefined entity in the given store
 @return        An NSArray of NSManagedObject instances
 */
-(NSArray *)fetchAllObjects;

/**
 @abstract      Fetches all objects associated with the predefined entity in the given store
 @param         sortDescriptors The sort descriptors used to define the array order
 @return        An NSArray of NSManagedObject instances
 */
-(NSArray *)fetchAllObjectsWithSortDescriptors:(NSArray *)sortDescriptors;

/**
 @abstract      Fetches all objects associated with the predefined entity in the given store
 @param         predicate The predicate used to filter this requests results
 @return        An NSArray of NSManagedObject instances
 */
-(NSArray *)fetchObjectsWithPredicate:(NSPredicate *)predicate;

/**
 @abstract      Fetches all objects associated with the predefined entity in the given store
 @param         sortDescriptors An array of sort descriptors used to sort the results
 @return        An NSArray of NSManagedObject instances
 */
-(NSArray *)fetchObjectsWithPredicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors;

/**
 @abstract      Fetches a specific object based on its identifier value
 @param         identifier The identifier to look up
 @param         create If this is set to YES, a new object will be created if it doesn't already exist
 @param         updateState The state of the object depending on whether it was found or created
 @return        An NSManagedObject instance, nil if not found and create=NO
 */
-(NSManagedObject *)fetchObjectWithIdentifier:(id)identifier
									   create:(BOOL)create
								 objectState:(SPXStoreObjectState *)updateState;

@end
