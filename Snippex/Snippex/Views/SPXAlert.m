/*
 Copyright (c) 2013 Snippex. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:1

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

#import "SPXAlert.h"
#import <objc/runtime.h>

static NSMutableArray *alerts;

@interface SPXAlert ()
@property (nonatomic, strong) SPXAlertCompletionBlock completion;
@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, strong) id alert;
@end

@implementation SPXAlert

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

        if (!alerts)
            alerts = [[NSMutableArray alloc] init];

        [alerts addObject:self];
	}

	return self;
}

-(void)showWithCompletion:(SPXAlertCompletionBlock)completion
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

-(id)alert
{
    return _alert;
}


@end