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

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <Foundation/Foundation.h>
#import "SPXDefines.h"

/**
 @abstract		Defines the completion block for an id<SPXAlertProtocol> instances.
 @param			buttonIndex The button index that was selected.
 */
typedef void (^SPXAlertCompletionBlock)(NSInteger buttonIndex);

/**
 This protocol defines the template for an alert that is supported across platforms. It is ideally used in conjunction with SPXErrorManager to present errors consistently across platforms.
 */
@protocol SPXAlertProtocol <NSObject>

/// @required
@required

/**
 @abstract		Initializes an alert component.
 @param			title The title of the alert.
 @param			message The message for the alert.
 @param			cancelTitle The title to display for this alerts cancel option.
 @param			otherTitles The titles to display for this alerts other buttons.
 @return			An NSAlert/UIAlert instance depending on platform.
 */
- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelTitle:(NSString *)cancelButtonTitle
		otherTitles:(NSArray *)otherButtonTitles;

/**
 @abstract		Displays the alert.
 @param			completion The completion block to call when a button is tapped.
 */
-(void)showWithCompletion:(SPXAlertCompletionBlock)completion;

/// @optional
@optional

/**
 @abstract		Initializes an alert component.
 @param			title The title of the alert.
 @param			message The message for the alert.
 @param			cancelButtonTitle The title to display for this alerts cancel option.
 @param			otherButtonTitles The titles to display for this alerts other buttons.
 @return			An NSAlert/UIAlert instance depending on platform.
 */
- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @abstract		Dismissed the alert after the specified delay.
 @param			delay The delay before dismissing.
 */
-(void)dismissWithDelay:(NSTimeInterval)delay;

#if TARGET_OS_IPHONE
-(UIAlertView *)alert;
#else
-(NSAlert *)alert;
#endif

@end

/**
 This class encapsulates the code required to consistently present an alert in iOS and OS X. 
 The button index returned is calculated using the titles to ensure its the same on both platforms. The indexes resemble that of a UIAlertView.
 */
#if TARGET_OS_IPHONE
@interface SPXAlert : NSObject <SPXAlertProtocol, UIAlertViewDelegate> // UIAlertView
#else
@interface SPXAlert : NSObject <SPXAlertProtocol>						 // NSAlert
#endif

@end