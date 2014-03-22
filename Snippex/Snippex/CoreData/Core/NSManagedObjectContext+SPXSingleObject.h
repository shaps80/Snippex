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

#import <CoreData/CoreData.h>
#import "SPXStoreDefines.h"

@interface NSManagedObjectContext (SPXSingleObject)

/**
 @abstract      Fetches a single object that matches the specified identifier
 @param         identifier The identifier of the object
 @param         name The entity name to use
 @discussion    create defaults to YES
 */
- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name;

/**
 @abstract      Fetches a single object that matches the specified identifier
 @param         identifier The identifier of the object
 @param         name The entity name to use
 @param         create If YES, creates the object if its not found
 useful for determining if it was created, or found
 */
- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name
            create:(BOOL)create;

/**
 @abstract      Fetches a single object that matches the specified identifier
 @param         identifier The identifier of the object
 @param         name The entity name to use
 @param         create If YES, creates the object if its not found
 @param         state Returns the state of the object
 useful for determining if it was created, or found
 */
- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name
            create:(BOOL)create
             state:(SPXStoreObjectState *)state;

/**
 @abstract      Fetches a single object that matches the specified identifier
 @param         identifier The identifier of the object
 @param         name The entity name to use
 @param         key The entity key to use for identifier comparisons
 @param         create If YES, creates the object if its not found
 @param         state Returns the state of the object
 useful for determining if it was created, or found
 */
- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name
               key:(NSString *)key
            create:(BOOL)create
             state:(SPXStoreObjectState *)state;

@end
