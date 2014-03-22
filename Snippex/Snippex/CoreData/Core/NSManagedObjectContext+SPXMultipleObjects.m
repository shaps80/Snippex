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

#import "NSManagedObjectContext+SPXMultipleObjects.h"
#import <objc/runtime.h>
#import "SPXStore.h"

@implementation NSManagedObjectContext (SPXMultipleObjects)

- (NSArray *)entitiesNamed:(NSString *)name
{
  return [self fetchEntitiesNamed:name predicate:nil sorting:nil];
}

- (NSArray *)entitiesNamed:(NSString *)name sorting:(NSArray *)sorting
{
  return [self fetchEntitiesNamed:name predicate:nil sorting:sorting];
}

- (NSArray *)entitiesNamed:(NSString *)name predicate:(id)predicateOrString, ...
{
  NSPredicate *predicate;
  
  if (predicateOrString)
  {
    if ([predicateOrString isKindOfClass:[NSString class]])
    {
      va_list variadicArguments;
      va_start(variadicArguments, predicateOrString);
      predicate = [NSPredicate predicateWithFormat:predicateOrString arguments:variadicArguments];
      va_end(variadicArguments);
    }
    else
    {
      NSAssert2([predicateOrString isKindOfClass:[NSPredicate class]],
                @"Second parameter passed to %s is of unexpected class %@",
                sel_getName(_cmd), [predicateOrString class]);
      
      predicate = (NSPredicate *)predicateOrString;
    }
  }
  
  return [self fetchEntitiesNamed:name predicate:predicate sorting:nil];
}

- (NSArray *)entitiesNamed:(NSString *)name sorting:(NSArray *)sorting predicate:(id)predicateOrString, ...
{
  NSPredicate *predicate;
  
  if ([predicateOrString isKindOfClass:[NSString class]])
  {
    va_list variadicArguments;
    va_start(variadicArguments, predicateOrString);
    predicate = [NSPredicate predicateWithFormat:predicateOrString arguments:variadicArguments];
    va_end(variadicArguments);
  }
  else
  {
    NSAssert2([predicateOrString isKindOfClass:[NSPredicate class]],
              @"Second parameter passed to %s is of unexpected class %@",
              sel_getName(_cmd), [predicateOrString class]);
    
    predicate = (NSPredicate *)predicateOrString;
  }
  
  return [self fetchEntitiesNamed:name predicate:predicate sorting:sorting];
}

#pragma mark - Private

- (NSArray *)fetchEntitiesNamed:(NSString *)name
                      predicate:(id)predicate
                        sorting:(NSArray *)sorting
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
  [request setPredicate:predicate];
  [request setSortDescriptors:sorting];
  
  NSError *error = nil;
  NSArray *results = [self executeFetchRequest:request error:&error];
  
  if (error) DLog(@"%@", error);
  return results;
}

- (NSString *)debugDescription
{
  id store = objc_getAssociatedObject(self, SPXStoreIdentifierKey);
  if (store) return [NSString stringWithFormat:@"%@", [store debugDescription]];
  else return [NSString stringWithFormat:@"%@", self];
}

@end
