//
//  SLAlert.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 11/04/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <Foundation/Foundation.h>

/**
 @abstract		Defines the completion block for an id<SLAlertProtocol> instances.
 @param			buttonIndex The button index that was selected.
 */
typedef void (^SLAlertCompletionBlock)(NSInteger buttonIndex);

/**
 This protocol defines the template for an alert that is supported across platforms. It is ideally used in conjunction with SLErrorManager to present errors consistently across platforms.
 */
@protocol SLAlertProtocol <NSObject>

/// @required
@required

/**
 @abstract		Initializes an alert component.
 @param			title The title of the alert.
 @param			message The message for the alert.
 @param			cancelTitle The title to display for this alerts cancel option.
 @param			otherTitles The titles to display for this alerts other buttons.
 @return		An NSAlert/UIAlert instance depending on platform.
 */
- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelTitle:(NSString *)cancelButtonTitle
		otherTitles:(NSArray *)otherButtonTitles;

/**
 @abstract		Displays the alert.
 @param			completion The completion block to call when a button is tapped.
 */
-(void)showWithCompletion:(SLAlertCompletionBlock)completion;

/// @optional
@optional

/**
 @abstract		Initializes an alert component.
 @param			title The title of the alert.
 @param			message The message for the alert.
 @param			cancelButtonTitle The title to display for this alerts cancel option.
 @param			otherButtonTitles The titles to display for this alerts other buttons.
 @return		An NSAlert/UIAlert instance depending on platform.
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

@end

/**
 This class encapsulates the code required to consistently present an alert in iOS and OS X. 
 The button index returned is calculated using the titles to ensure its the same on both platforms. The indexes resemble that of a UIAlertView.
 */
#if TARGET_OS_IPHONE
@interface SLAlert : NSObject <SLAlertProtocol, UIAlertViewDelegate> // UIAlertView
#else
@interface SLAlert : NSObject <SLAlertProtocol>						 // NSAlert
#endif

@end