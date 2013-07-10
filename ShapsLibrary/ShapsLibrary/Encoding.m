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

#define STRINGIFY(x) #x
#define OBJC_STRINGIFY(x) @#x
#define encodeObject(_variableName) [aCoder encodeObject:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define decodeObject(_variableName) _variableName = [aDecoder decodeObjectForKey:OBJC_STRINGIFY(_variableName)]

// for primitive types, use the following
#define encodeFloat(_variableName) [aCoder encodeFloat:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define encodeInteger(_variableName) [aCoder encodeInteger:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define encodeDouble(_variableName) [aCoder encodeDouble:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define encodeBool(_variableName) [aCoder encodeBool:_variableName forKey:OBJC_STRINGIFY(_variableName)]

#define decodeFloat(_variableName) _variableName = [aDecoder decodeFloatForKey:OBJC_STRINGIFY(_variableName)]
#define decodeInteger(_variableName) _variableName = [aDecoder decodeIntegerForKey:OBJC_STRINGIFY(_variableName)]
#define decodeDouble(_variableName) _variableName = [aDecoder decodeDoubleForKey:OBJC_STRINGIFY(_variableName)]
#define decodeBool(_variableName) _variableName = [aDecoder decodeBoolForKey:OBJC_STRINGIFY(_variableName)]

#if TARGET_OS_IPHONE

#define encodeRect(_variableName) [aCoder encodeCGRect:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define encodePoint(_variableName) [aCoder encodeCGPoint:_variableName forKey:OBJC_STRINGIFY(_variableName)]

#define decodeRect(_variableName) _variableName = [aDecoder decodeCGRectForKey:OBJC_STRINGIFY(_variableName)]
#define decodePoint(_variableName) _variableName = [aDecoder decodeCGPointForKey:OBJC_STRINGIFY(_variableName)]

#else

#define encodeRect(_variableName) [aCoder encodeRect:_variableName forKey:OBJC_STRINGIFY(_variableName)]
#define encodePoint(_variableName) [aCoder encodePoint:_variableName forKey:OBJC_STRINGIFY(_variableName)]

#define decodeRect(_variableName) _variableName = [aDecoder decodeRectForKey:OBJC_STRINGIFY(_variableName)]
#define decodePoint(_variableName) _variableName = [aDecoder decodePointForKey:OBJC_STRINGIFY(_variableName)]

#endif

@interface SampleEncoding : NSObject <NSCoding>
{
    CGFloat _float;
    NSInteger _integer;
    BOOL _bool;
    NSString *_string;
    CGRect _rect;
    CGPoint _point;
}
@end

@implementation SampleEncoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        decodeFloat(_float);
		decodeInteger(_integer);
        decodeBool(_bool);
		decodeObject(_string);
        decodeRect(_rect);
        decodePoint(_point);
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	encodeInteger(_integer);
    encodeFloat(_float);
    encodeBool(_bool);
	encodeObject(_string);
    encodeRect(_rect);
    encodePoint(_point);
}

@end
