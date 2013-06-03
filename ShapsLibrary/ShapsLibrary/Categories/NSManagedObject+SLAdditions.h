//
//  NSManagedObject+CLAdditions.h
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <objc/runtime.h>

/**
 An NSManagedObject category to provide consistent methods for constructing the model object from JSON and returning its JSON representation.
 */
@interface NSManagedObject (SLAdditions)

/// @abstract		Returns the JSON representation of this object.
-(NSDictionary *)JSONRepresentation;

/**
 @abstract		Sets the attributes for this object using the specified dictionary/json object.
 @param			attributes The JSON/dictionary of attributes to use for setting this objects properties.
 */
-(void)setAttributesFromJSON:(NSDictionary *)attributes;

@end