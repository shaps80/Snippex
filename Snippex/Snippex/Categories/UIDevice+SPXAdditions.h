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

#import <UIKit/UIKit.h>

#ifdef __MOBILECORESERVICES__
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#ifdef __COREMOTION__
#import <CoreMotion/CoreMotion.h>
#endif

typedef enum {
    SPXDeviceTypeUnknown,

    SPXDeviceTypeSimulator,
    SPXDeviceTypeSimulatoriPhone,
    SPXDeviceTypeSimulatoriPad,

    SPXDeviceType1GiPhone,
    SPXDeviceType3GiPhone,
    SPXDeviceType3GSiPhone,
    SPXDeviceType4iPhone,
    SPXDeviceType4SiPhone,
    SPXDeviceType5iPhone,

    SPXDeviceType1GiPod,
    SPXDeviceType2GiPod,
    SPXDeviceType3GiPod,
    SPXDeviceType4GiPod,

    SPXDeviceType1GiPad,
    SPXDeviceType2GiPad,
    SPXDeviceType3GiPad,
    SPXDeviceType4GiPad,

    SPXDeviceTypeUnknowniPhone,
    SPXDeviceTypeUnknowniPod,
    SPXDeviceTypeUnknowniPad,

} SPXDeviceType;

@interface UIDevice (SPXAdditions)

-(NSString *)deviceIdentifier;
-(NSString *)deviceName;
-(SPXDeviceType)deviceType;

-(BOOL)supportsRetina;

#if __MOBILECORESERVICES__
-(BOOL)supportsVideo;
#endif

#ifdef __COREMOTION__
-(BOOL)supportsGyroscope;
#endif

@end
