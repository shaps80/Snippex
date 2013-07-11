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

#import "SPXBreadCrumbItem.h"
#import "SPXGeometry.h"
#import "SPXView.h"

@protocol SPXBreadCrumbDelegate;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

/**
 This UI component represents a heirarchy using a breadcrumb style display. Its fairly specific to this project, however should be easily made reusable if drawing and styling code is abstracted nicely.

 This component is support on both __iOS__ and __OSX__
 */

@interface SPXBreadCrumbView : SPXView

#pragma mark -	Initializers
/// @name		Initializers

/**
 @abstract		Returns an instance with the specified items.
 @param			items An array of NSString instances representing each breadcrumb item.
 @discussion	You can pass either NSString or SPXBreadCrumbItem instances within the array.
 @return		An SPXBreadCrumbView instance with its items set.
 */
-(id)initWithItems:(NSArray *)items;

#pragma mark -	Properties
/// @name		Properties

/// @abstract	The delegate that will respond to events from this class.
@property (nonatomic, weak) id <SPXBreadCrumbDelegate> delegate;

/**
 @abstract		Sets the list of items.
 @discussion	You can pass either NSString or SPXBreadCrumbItem instances within this array.
 @return		Returns a copy of the items as SPXBreadCrumbItem instances.
 */
@property (nonatomic, copy) NSArray *items;

#pragma mark -	Editing Items
/// @name		Editing Items

/**
 @abstract		Adds the specified item to the end of the array.
 @param			item The item to add.
 @discussion	You can pass either NSString or SPXBreadCrumbItem instances.
 */
-(void)addItem:(id)item;

/**
 @abstract		Adds the specified item at the given index.
 @param			item The item to add.
 @param			index The index where this item should be inserted.
 @discussion	You can pass either NSString or SPXBreadCrumbItem instances.
 */
-(void)insertItem:(id)item atIndex:(NSInteger)index;

/**
 @abstract		Removes the item at the specified index.
 @param			index The index of the item to remove.
 */
-(void)removeItemAtIndex:(NSInteger)index;

#pragma mark -	Selection
/// @name		Selection

/**
 @abstract		Selects the breadcrumb item at the specified index.
 @param			index The index of the breadcrumb item.
 @discussion	This method will de-select any other items that are currently selected.
 */
-(void)selectItemAtIndex:(NSInteger)index;

/**
 @abstract		Determines if the breadcrumb item at the specified index is selected.
 @param			index The index of the bread crumb item.
 @return		YES if selected, NO otherwise.
 */
-(BOOL)isItemSelectedAtIndex:(NSInteger)index;

#pragma mark -	Behavior
/// @name		Behavior

/**
 @abstract		Sets a text position offset for a specific breadcrumb item position.
 @param			adjustment Sets the (x, y) offset for the text.
 @param			position The breadcrumb position, start, middle or end.
 */
#if TARGET_OS_IPHONE
-(void)setContentPositionAdjustment:(SPXOffset)adjustment
						forPosition:(SPXBreadCrumbItemPosition)position UI_APPEARANCE_SELECTOR;
#else
-(void)setContentPositionAdjustment:(SPXOffset)adjustment
						forPosition:(SPXBreadCrumbItemPosition)position;

/**
 @abstract		Sets the range of items that are scrollable. Default it a range with its location set to 0 and length set to 0.
 @param			range The range to make scrollable.
 @discussion	When there are too many items to fit the visible width, this component can be scrolled to show its hidden items. Settings a range here changes that behavior in that _only_ the specified range scrolls, anything outside this range stay on screen at all times. 
 E.g. A length of 0 regardless of location will have no effect. To make __only__ the second and third items fixed in their position we could pass the following range: 
 
	NSMakeRange(1, 2)
 */
-(void)setScrollableRange:(NSRange)range;

#endif

@end

/**
 This protocol defines the delegate methods that are called during event changes.
 */
@protocol SPXBreadCrumbDelegate <NSObject>

@optional

/**
 @abstract		This method is called when the user selects a breadcrumb item either via a touch, mouse or key event.
 @param			breadCrumb The SPXBreadCrumbView that triggered this method.
 @param			index The index of the SPXBreadCrumbItem that was selected.
 @discussion	Programmatically selecting an item does __not__ trigger this method.
 */
-(void)breadCrumb:(SPXBreadCrumbView *)breadCrumb didSelectItemAtIndex:(NSInteger)index;

/**
 @abstract		This method is called when the user selects a breadcrumb and another item was thus de-selected, either via a touch, mouse or key event.
 @param			breadCrumb The SPXBreadCrumbView that triggered this method.
 @param			index The index of the SPXBreadCrumbItem that was de-selected.
 @discussion	Programmatically de-selecting an item does __not__ trigger this method.
 */
-(void)breadCrumb:(SPXBreadCrumbView *)breadCrumb didDeSelectItemAtIndex:(NSInteger)index;

@end