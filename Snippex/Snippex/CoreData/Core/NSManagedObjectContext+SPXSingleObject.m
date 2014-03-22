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

#import "NSManagedObjectContext+SPXSingleObject.h"
#import <objc/runtime.h>
#import "SPXStore.h"

@implementation NSManagedObjectContext (SPXSingleObject)

- (id)objectWithID:(id)identifier entityNamed:(NSString *)name
{
  return [self objectWithID:identifier entityNamed:name create:YES state:nil];
}

- (id)objectWithID:(id)identifier entityNamed:(NSString *)name create:(BOOL)create
{
  return [self objectWithID:identifier entityNamed:name create:create state:nil];
}

- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name
            create:(BOOL)create
             state:(SPXStoreObjectState *)state
{
  SPXStore *store = objc_getAssociatedObject(self, SPXStoreIdentifierKey);
  return [self objectWithID:identifier entityNamed:name key:[store keyForEntityNamed:name] create:create state:state];
}

- (id)objectWithID:(id)identifier
       entityNamed:(NSString *)name
               key:(NSString *)key
            create:(BOOL)create
             state:(SPXStoreObjectState *)state
{
  return [self fetchObjectWithIdentifier:identifier forKey:key inEntityNamed:name create:create state:state];
}

#pragma mark - Private

- (NSArray *)fetchObjectWithIdentifier:(id)identifier
                                forKey:(NSString *)key
                         inEntityNamed:(NSString *)name
                                create:(BOOL)create
                                 state:(SPXStoreObjectState *)state
{
  SPXStoreObjectState objectState = SPXStoreObjectStateNotFound;
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
  NSString *format = [NSString stringWithFormat:@"%@ = %@", key, identifier];
  [request setPredicate:[NSPredicate predicateWithFormat:format]];
  
  NSError *error = nil;
  id object = [[self executeFetchRequest:request error:&error] lastObject];
  
  if (object) objectState = SPXStoreObjectStateFound;
  else
    if (!object && create)
    {
      object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
      objectState = SPXStoreObjectStateAdded;
    }
  
  if (state) *state = objectState;
  
  if (error) DLog(@"%@", error);
  return object;
}

@end
