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

#import "SPXSearchDatasource.h"

@interface SPXDatasource ()

@property (nonatomic, copy) SPXCellForIndexPathBlock cellBlock;
@property (nonatomic, copy) SPXTitleForHeaderInSectionBlock headerTitleBlock;
@property (nonatomic, copy) SPXTitleForFooterInSectionBlock footerTitleBlock;

@property (nonatomic, weak) UITableView *tableView;

@end

@interface SPXSearchDatasource ()

@property (nonatomic, copy) SPXSearchPredicateBlock predicateBlock;
@property (nonatomic, copy) SPXSearchSourceBlock sourceBlock;
@property (nonatomic, copy) NSMutableArray *source;
@property (nonatomic, copy) NSArray *results;

@end

@implementation SPXSearchDatasource

@synthesize tableView = _tableView;
@synthesize sortDescriptors = _sortDescriptors;

-(instancetype)initWithTableViewController:(UITableViewController *)controller
{
    self = [super init];

    if (self)
    {
        _tableView = controller.tableView;
        [controller.searchDisplayController setDelegate:self];
    }

    return self;
}

+(instancetype)dataSourceForTableViewController:(UITableViewController *)controller
{
    return [[SPXSearchDatasource alloc] initWithTableViewController:controller];
}

-(void)setSourceWithBlock:(SPXSearchSourceBlock)block
{
    _sourceBlock = block;
}

-(id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_results objectAtIndex:indexPath.row];
}

-(NSArray *)sectionsForTableView:(UITableView *)tableView
{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count;
}

#pragma mark - Public methods

-(void)setSortDescriptors:(NSArray *)sortDescriptors
{
    _sortDescriptors = sortDescriptors;
}

-(void)setSearchPredicate:(SPXSearchPredicateBlock)block
{
    _predicateBlock = block;
}

#pragma mark - SearchResults datasource

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    if (_sourceBlock)
        _source = [[_sourceBlock() sortedArrayUsingDescriptors:self.sortDescriptors] mutableCopy];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = nil;

    if (_predicateBlock)
    {
        predicate = _predicateBlock(searchString);
        _results = [_source filteredArrayUsingPredicate:predicate];
    }
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

@end
