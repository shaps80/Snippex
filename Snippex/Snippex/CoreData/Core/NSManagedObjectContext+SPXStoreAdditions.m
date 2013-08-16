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

#import "NSManagedObjectContext+SPXStoreAdditions.h"
#import "SPXStore.h"

#import <objc/runtime.h>

static char const * const SPXStoreKey = "SPX_store";

@implementation NSManagedObjectContext (SPXStoreAdditions)

- (NSString *)errorDomain
{
    return [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingPathExtension:@"SPXStore"];
}

- (NSError *)saveToStore
{
    __block NSError *error = nil;
    NSManagedObjectContext *context = self;

    while (context)
    {
        __block BOOL success = NO;

        [context performBlockAndWait:^{
            success = [context save:&error];
        }];

        if (!self.parentContext && !context.persistentStoreCoordinator)
        {
            error = [NSError errorWithDomain:[self errorDomain] code:-1
                                    userInfo:@{ NSLocalizedDescriptionKey :
                                                @"The context doesn't appear to belong to a persistent store" }];
        }

        context = context.parentContext;
    }

    return error;
}

#pragma mark - Count only

- (NSInteger)countForEntityNamed:(NSString *)name
{
    return [self countForEntityNamed:name predicate:nil];
}

- (NSInteger)countForEntityNamed:(NSString *)name predicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
    [request setPredicate:predicate];
    return [self countForFetchRequest:request error:nil];
}

#pragma mark - Multiple Items

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
    SPXStore *store = [self SPX_store];
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

#pragma mark - Internal

- (SPXStore *)SPX_store
{
    return objc_getAssociatedObject(self, SPXStoreKey);
}

- (void)setSPX_store:(SPXStore *)store
{
    objc_setAssociatedObject(self, SPXStoreKey, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
    id store = [self performSelector:@selector(SPX_store)];
    if (store) return [NSString stringWithFormat:@"%@", [store debugDescription]];
    else return [NSString stringWithFormat:@"%@", self];
}

@end
