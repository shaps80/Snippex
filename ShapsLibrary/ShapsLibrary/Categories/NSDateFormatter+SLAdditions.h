//
//  NSDateFormatter+Extensions.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An NSDateFormatter category
 */
@interface NSDateFormatter (SLAdditions)

/**
 @abstract Returns a shared NSDateFormatter singleton
 */
+(NSDateFormatter *)sharedFormatter;

@end