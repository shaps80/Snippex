/*
 Copyright (c) 2013 Shaps. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Shaps `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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