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

#import "SPXCollectionDatasource.h"

@interface SPXDatasource ()

@property (nonatomic, copy) SPXCellForIndexPathBlock cellBlock;
@property (nonatomic, copy) SPXTitleForHeaderInSectionBlock headerTitleBlock;
@property (nonatomic, copy) SPXTitleForFooterInSectionBlock footerTitleBlock;

@property (nonatomic, weak) UITableView *tableView;

@end

@interface SPXCollectionDatasource ()
@property (nonatomic, copy) NSMutableArray *source;
@end

@implementation SPXCollectionDatasource

@synthesize tableView = _tableView;
@synthesize sortDescriptors = _sortDescriptors;
@synthesize predicate = _predicate;
@synthesize source = _source;

+(instancetype)datasourceForTableView:(UITableView *)tableView
                               source:(NSArray *)source
{
    return [[SPXCollectionDatasource alloc] initWithTableView:tableView source:source];
}

-(instancetype)initWithTableView:(UITableView *)tableView
                          source:(NSArray *)source
{
    self = [super init];

    if (self)
    {
        _source = [source mutableCopy];
        _tableView = tableView;

        if (!_source)
            _source = [[NSMutableArray alloc] init];
    }

    return self;
}

-(NSArray *)source
{
    return [_source copy];
}

-(void)addObject:(id)object
{
    NSUInteger index = [_source indexOfObject:object
                                   inSortedRange:(NSRange){0, [_source count]}
                                         options:NSBinarySearchingInsertionIndex
                                 usingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 caseInsensitiveCompare:obj2];
    }];

    [_source insertObject:object atIndex:index];
    [_tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)removeObjectAtIndex:(NSInteger)index
{
    [_source removeObjectAtIndex:index];
    [_tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:0] ]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)setSortDescriptors:(NSArray *)sortDescriptors
{
    _sortDescriptors = sortDescriptors;
    [_source sortUsingDescriptors:sortDescriptors];
}

-(void)setPredicate:(NSPredicate *)predicate
{
    _predicate = predicate;
    [_source filterUsingPredicate:predicate];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _source.count;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return [NSIndexPath indexPathForRow:[_source indexOfObject:object] inSection:0];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_source objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		[_source removeObject:[self objectAtIndexPath:indexPath]];
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [tableView setEditing:NO animated:YES];
}

@end
