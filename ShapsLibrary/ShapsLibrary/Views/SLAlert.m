//
//  SLAlert.m
//  RESTCore
//
//  Created by Shaps Mohsenin on 11/04/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#import "SLAlert.h"
#import <objc/runtime.h>

static NSMutableArray *alerts;

@interface SLAlert ()
@property (nonatomic, strong) SLAlertCompletionBlock completion;
@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, strong) id alert;
@end

@implementation SLAlert

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	NSMutableArray *titles = [[NSMutableArray alloc] init];

	va_list args;
	va_start(args, otherButtonTitles);

	for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
		if (arg) [titles addObject:arg];

	va_end(args);

	return [self initWithTitle:title message:message cancelTitle:cancelButtonTitle otherTitles:titles];
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherTitles:(NSArray *)otherButtonTitles
{
	self = [super init];

	if (self)
	{
		_buttonTitles = [[NSMutableArray alloc] init];
		
#if TARGET_OS_IPHONE
		self.alert = [[UIAlertView alloc] initWithTitle:title
												message:message
											   delegate:self
									  cancelButtonTitle:cancelButtonTitle
									  otherButtonTitles:nil];
#else
		self.alert = [[NSAlert alloc] init];
		[self.alert setMessageText:title];
		[self.alert setInformativeText:message];

		if (cancelButtonTitle)
			[self.alert addButtonWithTitle:cancelButtonTitle];
#endif

		for (NSString *title in otherButtonTitles)
		{
			[self.alert addButtonWithTitle:title];
			[_buttonTitles addObject:title];
		}

		if (cancelButtonTitle)
			[_buttonTitles insertObject:cancelButtonTitle atIndex:0];
	}

	if (!alerts)
		alerts = [[NSMutableArray alloc] init];
	
	[alerts addObject:self];

	return self;
}

-(void)showWithCompletion:(SLAlertCompletionBlock)completion
{
	_completion = completion;

#if TARGET_OS_IPHONE
	[self.alert show];
#else
	[self.alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEndSheet:returnCode:contextInfo:) contextInfo:nil];
#endif
}

#if TARGET_OS_IPHONE

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex < 0 || buttonIndex > _buttonTitles.count - 1)
		return;

	NSString *title = [self.alert buttonTitleAtIndex:buttonIndex];

	if (_completion && _buttonTitles.count)
		_completion([_buttonTitles indexOfObject:title]);

	[alerts removeLastObject];
}

#else

- (void)alertDidEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	NSInteger result = returnCode - 1000;
	if (![[self.alert buttons] count])
		return;

	NSString *title = [[[self.alert buttons] objectAtIndex:result] title];
	
	if (_completion && _buttonTitles.count)
		_completion([_buttonTitles indexOfObject:title]);

    [[self.alert window] orderOut:nil];
	[alerts removeLastObject];
}

#endif

-(void)dismissWithDelay:(NSTimeInterval)delay
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
	{
#if TARGET_OS_IPHONE
		[_alert dismissWithClickedButtonIndex:-1 animated:YES];
#else
		[[_alert window] orderOut:nil];
		[alerts removeLastObject];
#endif
	});
}


@end