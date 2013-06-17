/*
 Copyright (c) 2013 Shaps. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Shaps `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SLBreadCrumbView.h"
#import "BezierPath+SLAdditions.h"

@interface SLBreadCrumbItem (SLBreadcrumbControlPrivateAccess)

// The current state of the item.
@property (nonatomic) SLControlState state;

// The current position of the item.
@property (nonatomic) SLBreadCrumbItemPosition position;

// The width required for the item at the specified index.
-(CGFloat)requiredWidthForItemAtIndex:(NSInteger)index;

@end

@interface SLBreadCrumbView ()
{
	NSMutableArray *_items;
	NSMutableDictionary *_itemPositionOffsets;
}

@end

@implementation SLBreadCrumbView

#pragma mark - Lifecycle

-(id)initWithItems:(NSArray *)items
{
	self = [super init];

	if (self)
		[self setItems:items];

	return self;
}

-(void)setItems:(NSArray *)items
{
	if (_items.count || _items == items)
		return;

	// remove existing items from superview, then re-populate with new items.
	[_items makeObjectsPerformSelector:@selector(removeFromSuperview)];

	_items = nil;
	_items = [[NSMutableArray alloc] init];

	for (id item in items)
		[self insertItem:item atIndex:_items.count];
	
	[self setLayoutRequired];
	[self setDrawingRequired];
}

-(NSArray *)items
{
	@synchronized (_items)
	{
		return [_items copy];
	}
}

-(void)addItem:(id)item
{
	[self insertItem:item atIndex:_items.count];
}

// All adding/inserting/setting does the actual adding of to the array and view here!
-(void)insertItem:(id)item atIndex:(NSInteger)index
{
	NSAssert1(([item isKindOfClass:[NSString class]] || [item isKindOfClass:[SLBreadCrumbItem class]]),
			  @"SLBreadCrumbView expects NSString or SLBreadCrumbItem instances only!", item);

	SLBreadCrumbItem *breadCrumbItem = item;

	if ([item isKindOfClass:[NSString class]])
		breadCrumbItem = [[SLBreadCrumbItem alloc] initWithText:item];

	if (!_items)
		_items = [[NSMutableArray alloc] init];

	[self willChangeValueForKey:@"items"];
	[_items insertObject:breadCrumbItem atIndex:index];
	[self didChangeValueForKey:@"items"];

	[self addSubview:breadCrumbItem];
	
	[self setLayoutRequired];
	[self setDrawingRequired];
}

// All removing from the array and view occurs here.
-(void)removeItemAtIndex:(NSInteger)index
{
	SLBreadCrumbItem *item = [_items objectAtIndex:index];
	[item removeFromSuperview];

	[self willChangeValueForKey:@"items"];
	[_items removeObjectAtIndex:index];
	[self didChangeValueForKey:@"items"];

	[self setLayoutRequired];
	[self setDrawingRequired];
}

-(void)selectItemAtIndex:(NSInteger)index
{
	for (int i = 0; i > _items.count; i++)
	{
		SLBreadCrumbItem *item = [_items objectAtIndex:i];

		if (index == i)
			[item setState:SLControlStateSelected];
		else
			[item setState:SLControlStateNormal];
	}
}

-(BOOL)isItemSelectedAtIndex:(NSInteger)index
{
	SLBreadCrumbItem *item = [_items objectAtIndex:index];
	return (item.state == SLControlStateSelected);
}

#pragma mark - Public Methods

-(void)setScrollableRange:(NSRange)range
{
	[self setLayoutRequired];
}

-(void)setContentPositionAdjustment:(SLOffset)adjustment forPosition:(SLBreadCrumbItemPosition)position
{
	[self setLayoutRequired];
}

#pragma mark - Drawing

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

#if TARGET_OS_IPHONE
	SLBezierPath *path3 = [SLBezierPath bezierPathWithRoundedRect:CGRectMake(40, 10, 20, 20) cornerRadius:4];
#else
	SLBezierPath *path3 = [SLBezierPath bezierPathWithRoundedRect:CGRectMake(40, 10, 20, 20) xRadius:4 yRadius:4];
#endif

	SLShadow *shadow = [[SLShadow alloc] initWithColor:[SLColor darkGrayColor] offset:CGSizeMake(1, 1) radius:3];
//	[shadow drawInnerShadowForPath:path3];
	[path3 fillWithInnerShadow:shadow];

	[[SLColor darkGrayColor] set];
	[path3 stroke];
}

#pragma mark - Layout

-(void)layoutBreadCrumbItems
{
	for (int i = 0; i < _items.count; i++)
	{
//		SLBreadCrumbItem *item = [_items objectAtIndex:i];
//		item = nil;
	}
}

-(void)layoutViews
{
	[self layoutBreadCrumbItems];
	[super layoutViews];
}

@end
