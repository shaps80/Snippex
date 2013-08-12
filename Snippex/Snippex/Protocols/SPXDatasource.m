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

#import "SPXDatasource.h"

@interface SPXDatasource ()

@property (nonatomic, copy) SPXCellForIndexPathBlock cellBlock;
@property (nonatomic, copy) SPXTitleForHeaderInSectionBlock headerTitleBlock;
@property (nonatomic, copy) SPXTitleForFooterInSectionBlock footerTitleBlock;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SPXDatasource

#pragma mark - Private Getters

- (NSIndexPath *)indexPathForObject:(id)object
{
    return nil;
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSArray *)sectionsForTableView:(UITableView *)tableView
{
    return nil;
}

#pragma mark - TableView datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellBlock)
    {
        id object = [self objectAtIndexPath:indexPath];
        return self.cellBlock(tableView, object, indexPath);
    }
    else
        return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        [tableView scrollRectToVisible:CGRectZero animated:NO];
        return -1;
    }

    if ([title isEqual: @"#"] || title == UITableViewIndexSearch)
    {
        CGRect rect = CGRectZero;
        [tableView scrollRectToVisible:rect animated:NO];
        return -1;
    }

    for (int i = [[self sectionsForTableView:tableView] count] -1; i >= 0; i--)
    {
        NSString *indexTitle = [[[self sectionsForTableView:tableView] objectAtIndex:i] indexTitle];
        NSComparisonResult cr = [title caseInsensitiveCompare:indexTitle];

        if (cr == NSOrderedSame || cr == NSOrderedDescending)
            return i;
    }
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.footerTitleBlock)
        return self.footerTitleBlock(tableView, section);
    else
        return nil;
}

#pragma mark - Defaults

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER
{
    [tableView setEditing:NO animated:YES];
}

#pragma mark - Setters

-(void)setSectionIndexMinimumDisplayRowCount:(NSInteger)count
{
    [_tableView setSectionIndexMinimumDisplayRowCount:count];
}

-(void)setCellForRowAtIndexPathBlock:(SPXCellForIndexPathBlock)block
{
    self.cellBlock = block;
}

-(void)setTitleForHeaderInSectionBlock:(SPXTitleForHeaderInSectionBlock)block
{
    self.headerTitleBlock = block;
}

-(void)setTitleForFooterInSectionBlock:(SPXTitleForFooterInSectionBlock)block
{
    self.footerTitleBlock = block;
}

@end
