//
//  SLDefines.h
//  RESTCore
//
//  Created by Shaps Mohsenin on 10/03/13.
//  Copyright (c) 2013 Shaps Mohsenin. All rights reserved.
//

/**
 Here are various definitions to simplify implementation across platforms.
 You can use these methods throughout your code, as does all the Core code
 to ensure the correct classes are used on each platform. e.g. (NSColor vs UIColor)
 */

#if TARGET_OS_IPHONE

#define SLContext UIGraphicsGetCurrentContext()

#define SLColor UIColor
#define SLColorRGBMake(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define SLColorWhiteMake(w,a) [UIColor colorWithWhite:w alpha:a]

#define SLBezierPath UIBezierPath

#else

#define SLContext [[NSGraphicsContext currentContext] graphicsPort]

#define SLColor NSColor
#define SLColorRGBMake(r,g,b,a) [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a]
#define SLColorWhiteMake(w,a) [NSColor colorWithCalibratedWhite:w alpha:a]

#define SLBezierPath NSBezierPath

#endif