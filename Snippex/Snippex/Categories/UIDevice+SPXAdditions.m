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

#import "UIDevice+SPXAdditions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING       @"iPhone"

#define IPOD_1G_NAMESTRING              @"iPod Touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod Touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod Touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod Touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"iPad"

#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"

@implementation UIDevice (SPXAdditions)

-(NSString *)deviceIdentifier
{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *identifier = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	return identifier;
}

-(NSString *)deviceName
{
	switch ([self deviceType])
    {
        case SPXDeviceType1GiPhone:			return IPHONE_1G_NAMESTRING;
        case SPXDeviceType3GiPhone:			return IPHONE_3G_NAMESTRING;
        case SPXDeviceType3GSiPhone:		return IPHONE_3GS_NAMESTRING;
        case SPXDeviceType4iPhone:			return IPHONE_4_NAMESTRING;
        case SPXDeviceType4SiPhone:			return IPHONE_4S_NAMESTRING;
        case SPXDeviceType5iPhone:			return IPHONE_5_NAMESTRING;
        case SPXDeviceTypeUnknowniPhone:	return IPHONE_UNKNOWN_NAMESTRING;

        case SPXDeviceType1GiPod:			return IPOD_1G_NAMESTRING;
        case SPXDeviceType2GiPod:			return IPOD_2G_NAMESTRING;
        case SPXDeviceType3GiPod:			return IPOD_3G_NAMESTRING;
        case SPXDeviceType4GiPod:			return IPOD_4G_NAMESTRING;
        case SPXDeviceTypeUnknowniPod:		return IPOD_UNKNOWN_NAMESTRING;

        case SPXDeviceType1GiPad :			return IPAD_1G_NAMESTRING;
        case SPXDeviceType2GiPad :			return IPAD_2G_NAMESTRING;
        case SPXDeviceType3GiPad :			return IPAD_3G_NAMESTRING;
        case SPXDeviceType4GiPad :			return IPAD_4G_NAMESTRING;
        case SPXDeviceTypeUnknowniPad :		return IPAD_UNKNOWN_NAMESTRING;

        case SPXDeviceTypeSimulatoriPhone:	return SIMULATOR_IPHONE_NAMESTRING;
        case SPXDeviceTypeSimulatoriPad:	return SIMULATOR_IPAD_NAMESTRING;

        default: return @"Unknown Device";
    }
}

-(SPXDeviceType)deviceType
{
	NSString *identifier = [self deviceIdentifier];

    if ([identifier isEqualToString:@"iPhone1,1"])    return SPXDeviceType1GiPhone;
    if ([identifier isEqualToString:@"iPhone1,2"])    return SPXDeviceType3GiPhone;
    if ([identifier hasPrefix:@"iPhone2"])            return SPXDeviceType3GSiPhone;
    if ([identifier hasPrefix:@"iPhone3"])            return SPXDeviceType4iPhone;
    if ([identifier hasPrefix:@"iPhone4"])            return SPXDeviceType4SiPhone;
    if ([identifier hasPrefix:@"iPhone5"])            return SPXDeviceType5iPhone;

    if ([identifier hasPrefix:@"iPod1"])              return SPXDeviceType1GiPod;
    if ([identifier hasPrefix:@"iPod2"])              return SPXDeviceType2GiPod;
    if ([identifier hasPrefix:@"iPod3"])              return SPXDeviceType3GiPod;
    if ([identifier hasPrefix:@"iPod4"])              return SPXDeviceType4GiPod;

    if ([identifier hasPrefix:@"iPad1"])              return SPXDeviceType1GiPad;
    if ([identifier hasPrefix:@"iPad2"])              return SPXDeviceType2GiPad;
    if ([identifier hasPrefix:@"iPad3"])              return SPXDeviceType3GiPad;
    if ([identifier hasPrefix:@"iPad4"])              return SPXDeviceType4GiPad;

    if ([identifier hasPrefix:@"iPhone"])             return SPXDeviceTypeUnknowniPhone;
    if ([identifier hasPrefix:@"iPod"])               return SPXDeviceTypeUnknowniPod;
    if ([identifier hasPrefix:@"iPad"])               return SPXDeviceTypeUnknowniPad;

    if ([identifier hasSuffix:@"86"] || [identifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? SPXDeviceTypeSimulatoriPhone : SPXDeviceTypeSimulatoriPad;
    }
    
	return SPXDeviceTypeUnknown;
}

-(BOOL)supportsRetina
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
		scale = screen.scale;

	if(scale == 2.0f) return YES;
	else return NO;
}

-(BOOL)supportsGyroscope
{
#ifdef __IPHONE_4_0
	CMMotionManager *motionManager = [[CMMotionManager alloc] init];
	BOOL gyroAvailable = motionManager.gyroAvailable;
	return gyroAvailable;
#else
	return NO;
#endif
}

-(BOOL)supportsVideo
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
	return [sourceTypes containsObject:(NSString *)kUTTypeMovie];
}

@end
