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

#import "SPXRuntime.h"

void dumpClass(Class cls)
{
    const char *className = class_getName(cls);

    Class isa = object_getClass(cls);
    Class superClass = class_getSuperclass(cls);

    NSLog(@"Class       |   %@", isa);
    NSLog(@"SuperClass  |   %@", superClass);

    NSLog(@"\n");

    unsigned int protocolCount = 0;
    Protocol *__unsafe_unretained* protocolList = class_copyProtocolList(cls, &protocolCount);

    if (protocolCount == 0) NSLog(@"Protocols: NONE\n");
    else NSLog(@"Protocols:");

    for (unsigned int i = 0; i < protocolCount; i++) {
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSLog(@"<%s>", name);
    }
    free(protocolList);

    NSLog(@"\n");

    unsigned int ivarCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &ivarCount);

    if (ivarCount == 0) NSLog(@"Instance Variables: NONE\n");
    else NSLog(@"Instance Variables:");

    for (unsigned int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarList[i];
        const char *name = ivar_getName(ivar);
        NSLog(@"  %s", name);
    }
    free(ivarList);

    NSLog(@"\n");

    unsigned int instanceMethodCount = 0;
    Method *instanceMethodList = class_copyMethodList(cls, &instanceMethodCount);

    if (instanceMethodCount == 0) NSLog(@"Instance Methods: NONE\n");
    else NSLog(@"Instance Methods:");

    for (unsigned int i = 0; i < instanceMethodCount; i++) {
        Method method = instanceMethodList[i];
        SEL name = method_getName(method);
        NSLog(@"  -[%s %@]", className, NSStringFromSelector(name));
    }
    free(instanceMethodList);

    NSLog(@"\n");

    unsigned int classMethodCount = 0;
    Method *classMethodList = class_copyMethodList(isa, &classMethodCount);

    if (classMethodCount == 0) NSLog(@"Class Methods: NONE\n");
    else NSLog(@"Class Methods:");

    for (unsigned int i = 0; i < classMethodCount; i++) {
        Method method = classMethodList[i];
        SEL name = method_getName(method);
        NSLog(@"  +[%s %@]", className, NSStringFromSelector(name));
    }
    free(classMethodList);

    NSLog(@"\n");
}