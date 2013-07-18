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

#import "SPXDefines.h"

#pragma mark - Views

#import "SPXView.h"
#import "SPXControl.h"
#import "SPXAlert.h"
#import "SPXBreadCrumbView.h"

#pragma mark - Managers

#import "SPXCoreDataManager.h"
#import "SPXErrorManager.h"

#pragma mark - Graphics

#import "SPXGraphicsDefines.h"
#import "SPXGeometry.h"
#import "SPXDrawing.h"
#import "SPXGradient.h"
#import "SPXShadow.h"

#pragma mark - Wrappers

#import "SPXStore.h"

#pragma mark - Categories

#ifdef DEBUG
#import "NSBlock+SPXAdditions.h"
#elif !TARGET_OS_IPHONE
#import "Color+SPXAdditions.h"
#endif

#import "BezierPath+SPXAdditions.h"
#import "NSData+SPXAdditions.h"
#import "NSDateFormatter+SPXAdditions.h"
#import "NSDictionary+SPXAdditions.h"
#import "NSManagedObject+SPXAdditions.h"
#import "NSManagedObjectContext+SPXAdditions.h"
#import "NSString+SPXAdditions.h"
#import "Color+SPXAdditions.h"

