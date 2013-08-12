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

/**
 */
@interface SPXError : NSObject

/**
  @abstract      Initializes this object with the specified dictionary
 */
+ (void)initializeDictionary:(NSDictionary *)dictionary;

/**
  @abstract      Initializes this object with the specified plist, at the given URL
 */
+ (void)initializePlist:(NSURL *)url;

/**
  @abstract      Returns an NSError object with the specified code, domain, full and short descriptions.
 */
+ (NSError *)errorForCode:(NSInteger)code;

/**
 @abstract      Returns a detailed description of what happened, could be directly from server
 */
+ (NSString *)messageForCode:(NSInteger)code;

/**
 @abstract      Returns a short message useful in an alert
 */
+ (NSString *)shortMessageForCode:(NSInteger)code;

/**
 @abstract      Returns the message for the specified code, with the given prefix and suffix surrounding to the string
 @discussion    This is useful for providing generic messages in the plist, but then specialising them here.
    
    E.g.    message - "Failed to create"
            prefix  - nil
            suffix  - "'object123'"
            
            result  - "Failed to create 'object123'"
 */
+ (NSString *)messageForCode:(NSInteger)code withPrefix:(NSString *)prefix suffix:(NSString *)suffix;

/**
 @abstract      Returns an NSError from this NSError.
 @return        If the Plist contains error messages for this code, the returned NSError will contain this NSError's domain and code, but the messages found in the Plist, otherwise the Plist is left unchanged.
 */
+ (NSError *)errorForError:(NSError *)error;

@end
