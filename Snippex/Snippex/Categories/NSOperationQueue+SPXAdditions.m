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

#import "NSOperationQueue+SPXAdditions.h"

@implementation NSOperationQueue (SPXAdditions)

- (void)setLIFODependendenciesForOperation:(NSOperation *)operation
{
    @synchronized(self)
    {
        // suspend queue
        BOOL wasSuspended = [self isSuspended];
        [self setSuspended:YES];

        // make op a dependency of all queued ops
        NSInteger maxOperations = ([self maxConcurrentOperationCount] > 0) ? [self maxConcurrentOperationCount]: INT_MAX;
        NSArray *operations = [self operations];
        NSInteger index = [operations count] - maxOperations;

        if (index >= 0)
        {
            NSOperation *operation = operations[index];

            if (![operation isExecuting])
                [operation addDependency:operation];
        }

        // resume queue
        [self setSuspended:wasSuspended];
    }
}

- (void)addOperationAtFrontOfQueue:(NSOperation *)operation
{
    [self setLIFODependendenciesForOperation:operation];
    [self addOperation:operation];
}

- (void)addOperationsAtFrontOfQueue:(NSArray *)operations waitUntilFinished:(BOOL)wait
{
    for (NSOperation *operation in operations)
    {
        [self setLIFODependendenciesForOperation:operation];
    }

    [self addOperations:operations waitUntilFinished:wait];
}

- (void)addOperationAtFrontOfQueueWithBlock:(void (^)(void))block
{
    [self addOperationAtFrontOfQueue:[NSBlockOperation blockOperationWithBlock:block]];
}

@end
