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

#ifndef _SNIPPEX_H_
#define _SNIPPEX_H_

    #import "SPXDefines.h"

    #if TARGET_OS_IPHONE
    #import "SPXBarButtonItem.h"
    #import "SPXDatasource.h"
    #import "SPXCoreDataDatasource.h"
    #import "SPXSearchDatasource.h"
    #import "SPXCollectionDatasource.h"
    #import "UIDevice+SPXAdditions.h"
    #endif

    #import "SPXView.h"
    #import "SPXControl.h"
    #import "SPXAlert.h"
    #import "SPXError.h"
    #import "SPXGraphicsDefines.h"
    #import "SPXGeometry.h"
    #import "SPXDrawing.h"
    #import "SPXGradient.h"
    #import "SPXShadow.h"
    #import "SPXStore.h"
    #import "SPXRest.h"
    #import "BezierPath+SPXAdditions.h"
    #import "NSData+SPXAdditions.h"
    #import "NSDateFormatter+SPXAdditions.h"
    #import "NSDictionary+SPXRestQueryString.h"
    #import "NSString+SPXRestQueryString.h"
    #import "Color+SPXAdditions.h"
    #import "SPXAudio.h"
    #import "SPXReachability.h"
    #import "SPXKeyValueStore.h"
    #import "SPXImageCache.h"
    #import "SPXSemaphore.h"

#endif