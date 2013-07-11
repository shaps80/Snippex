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

#import <Foundation/Foundation.h>
#import "SPXAlert.h"

/// The dictionary key for the alert title
extern const NSString *kCLErrorUserTitle;
/// The dictionary key for the alert description
extern const NSString *kCLErrorUserDescription;
/// The dictionary key for the alert cancel title
extern const NSString *kCLErrorCancelButton;
/// The dictionary key for the alert button titles array
extern const NSString *kCLErrorOtherButtons;

/**

 This class provides class specific error management for an application based on values retrieved from a plist or NSDictionary. For localization support, simply localize the plist file. 
 
 **Note**
 If the specified alert class has implemented -dismissWithDelay: and the returned error hasn't specified any button title values, this class will automatically call -dimissWithDelay: with a delay of 1 second for you.

 **Plist structure**

	 <dict>
		 <key>NSManagedObject</key>
		 <dict>
			 <key>0</key>
			 <dict>
				 <key>UserTitle</key>
				 <string>Failed</string>
				 <key>UserDescription</key>
				 <string>An unknown error occurred.</string>
				 <key>CancelButtonTitle</key>
				 <string>No</string>
				 <key>OtherButtonTitles</key>
				 <array>
					 <string>Yes</string>
				 </array>
			 </dict>
		 </dict>
	 </dict>

 **Default Error**
 
 This error is used when no object definition can be found in the Plist.

	 Title		->		"Failed"
	 Message	->		"An unknown error occurred."

 */

@interface SPXErrorManager : NSObject

#pragma mark -	Intializer
/// @name		Intializer

/**
 @abstract		Returns a singleton instance that will automatically load Errors.plist from the main bundle. If the plist doesn't exist and NSException will occur.

 @exception		SPXFileNotFoundException Occurs when the plist file cannot be found in the main bundle.
 @discussion		This method doesn't currently validate the plist file so please use the documentation to determine is correct structure.
*/
+(SPXErrorManager *)sharedInstance;

/**
 @abstract		Initializes the singleton class with the specified plist.
 @param			urlToPlist The URL to the plist to load.
 @discussion		This should only be called when using the SPXErrorManager singleton instance.
 @exception		NSInvalidArgumentException Occurs if the plist cannot be found at the specified url or cannot be loaded.
 */
+(void)initializeWithPlist:(NSURL *)urlToPlist;

/**
 @abstract		Initializes the singleton class with the specified dictioanry.
 @param			dictionary The dictionary to read from.
 @discussion		This should only be called when using the SPXErrorManager singleton instance.
 @exception		NSInvalidArgumentException Occurs if the specified dictionary is invalid.
 */
+(void)initializeWithDictionary:(NSDictionary *)dictionary;

/**
 @abstract		Initializer for a plist based error manager.
 @param			urlToPlist The url to the plist to load.
 @return			An SPXErrorManager class, using a plist file as its source.
 @exception		NSInvalidArgumentException Occurs if the plist cannot be found at the specified url or cannot be loaded.
 */
-(id)initWithPlist:(NSURL *)urlToPlist;

/**
 @abstract		Initializer for a dictionary based error manager.
 @param			dictionary The dictionary to read from.
 @return			An SPXErrorManager class, using a dictionary file as its source.
 */
-(id)initWithDictionary:(NSDictionary *)dictionary;

/**
 @abstract		Registers the alert class to use for presenting errors.
 @param			alertViewClass The alert class that conforms to SPXAlertProtocol.
 */
-(void)registerAlertViewClass:(Class/*<SPXAlertProtocol>*/)alertViewClass;

#pragma mark -	Setup
/// @name		Setup

#pragma mark -	Presenting Errors
/// @name		Presenting Errors

/**
 @abstract		Presents a UIAlertView with the appropriate title, message and button titles.

 @param			errorCode The error code to lookup.
 @param			class The class to lookup.
 @param			completion The completion block to execute when the alert is dismissed.
 
 @discussion	The errorCode and class variables are used to lookup the plist/dictionary entries and set the title, message and button titles accordingly.
 */
-(void)presentErrorForCode:(NSInteger)errorCode class:(Class)class
				completion:(SPXAlertCompletionBlock)completion;

/**
 @abstract		Presents a UIAlertView with the appropriate title, message and button titles.

 @param			error The NSError, currently we only use the error.code property from this instance.
 @param			class The class to lookup.
 @param			completion The completion block to execute when the alert is dismissed.

 @discussion	The error.code and class variables are used to lookup the plist/dictionary entries and set the title, message and button titles accordingly.
 */
-(void)presentErrorForError:(NSError *)error class:(Class)class
				 completion:(SPXAlertCompletionBlock)completion;

#pragma mark -	Getting Error Information
/// @name		Getting Error Information

/**
 @abstract		Returns the message string only for a given code/class.
 
 @param			code The error code to lookup.
 @param			class The class to lookup.
 */
-(NSString *)messageForCode:(NSInteger)code class:(Class)class;

/**
 @abstract		Returns the message string only for a given code/class.

 @param			error We use the error to get the error-code to lookup.
 @param			class The class to lookup.
 */
-(NSString *)messageForError:(NSError *)error class:(Class)class;

/**
 @abstract		Gets the title and message for a given code/class.
 
 @param			code The error-code to lookup.
 @param			class The class to lookup.
 @param			title An address to an NSString instance, this method will set its value to the title value.
 @param			message An address to an NSString instance, this method will set its value to the message value.
 */
-(void)errorForCode:(NSInteger)code
			  class:(Class)class
			  title:(NSString **)title
			message:(NSString **)message;

/**
 @abstract		Gets the title, message and button titles for a given code/class.

 @param			code The error-code to lookup.
 @param			class The class to lookup.
 @param			title An address to an NSString instance, this method will set its value to the title value.
 @param			message An address to an NSString instance, this method will set its value to the message value.
 @param			cancelTitle An address to an NSString instance, this method will set its value to the cancel button title value.
 @param			otherTitles An address to an NSArray instance, this method will set its value to an array of titles.
 */
-(void)errorForCode:(NSInteger)code
			  class:(Class)class
			  title:(NSString **)title
			message:(NSString **)message
  cancelButtonTitle:(NSString **)cancelTitle
  otherButtonTitles:(NSArray **)otherTitles;

/**
 @abstract		Gets the title, message and button titles for a given error/class.

 @param			error The error to use to get the error-code to lookup.
 @param			class The class to lookup.
 @param			title An address to an NSString instance, this method will set its value to the title value.
 @param			message An address to an NSString instance, this method will set its value to the message value.
 @param			cancelTitle An address to an NSString instance, this method will set its value to the cancel button title value.
 @param			otherTitles An address to an NSArray instance, this method will set its value to an array of titles.
 */
-(void)errorForError:(NSError *)error
  		       class:(Class)class
			   title:(NSString **)title
			 message:(NSString **)message
   cancelButtonTitle:(NSString **)cancelTitle
   otherButtonTitles:(NSArray **)otherTitles;

@end