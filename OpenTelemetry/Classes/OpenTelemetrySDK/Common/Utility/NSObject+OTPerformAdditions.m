//
//  NSObject+OTPerformAdditions.m
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import "NSObject+OTPerformAdditions.h"

@implementation NSObject (OTPerformAdditions)

- (id)ot_utGetReturnValue:(NSInvocation *)invo {
    NSMethodSignature *sig = invo.methodSignature;
    const char *returnType = sig.methodReturnType;

    if (0 == strcmp(returnType, @encode(void))) {
        return nil;
    } else if (0 == strcmp(returnType, @encode(id))) {
        __autoreleasing id anObject = nil;
        [invo getReturnValue:&anObject];
        return anObject;
    } else {
        // 简单类型
        NSUInteger length = [sig methodReturnLength];
        if (length > 0) {
            void *buffer = (void *)malloc(length);
            [invo getReturnValue:buffer];
            if (0 == strcmp(returnType, @encode(BOOL))) {
                return [NSNumber numberWithBool:*((BOOL *)buffer)];
            } else if (0 == strcmp(returnType, @encode(int))) {
                return [NSNumber numberWithInt:*((int *)buffer)];
            } else if (0 == strcmp(returnType, @encode(unsigned int))) {
                return [NSNumber numberWithUnsignedInt:*((unsigned int *)buffer)];
            } else if (0 == strcmp(returnType, @encode(long))) {
                return [NSNumber numberWithLong:*((long *)buffer)];
            } else if (0 == strcmp(returnType, @encode(unsigned long))) {
                return [NSNumber numberWithUnsignedLong:*((unsigned long *)buffer)];
            } else if (0 == strcmp(returnType, @encode(long long))) {
                return [NSNumber numberWithLongLong:*((long long *)buffer)];
            } else if (0 == strcmp(returnType, @encode(unsigned long long))) {
                return [NSNumber numberWithUnsignedLongLong:*((unsigned long long *)buffer)];
            } else if (0 == strcmp(returnType, @encode(double))) {
                return [NSNumber numberWithDouble:*((double *)buffer)];
            } else if (0 == strcmp(returnType, @encode(float))) {
                return [NSNumber numberWithFloat:*((float *)buffer)];
            } else {
                return [NSValue valueWithBytes:buffer objCType:returnType];
            }
        } else {
            return nil;
        }
    }
}

- (id)ot_utPerformSelector:(SEL)selector {
    if (!selector) {
        return nil;
    }

    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
    /*
     SEL selector = NSSelectorFromString(@"someMethod");
     IMP imp = [delegate methodForSelector:selector];
     void (*func)(id, SEL, id) = (void *)imp;
     func(delegate, selector, p1);
     */
}

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 {
    if (!selector) {
        return nil;
    }

    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    if (!selector) {
        return nil;
    }

    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
    if (!selector) {
        return nil;
    }
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        if (p3) {
            [invo setArgument:&p3 atIndex:4];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 {
    if (!selector) {
        return nil;
    }
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        if (p3) {
            [invo setArgument:&p3 atIndex:4];
        }
        if (p4) {
            [invo setArgument:&p4 atIndex:5];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 withObject:(id)p5 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        if (p3) {
            [invo setArgument:&p3 atIndex:4];
        }
        if (p4) {
            [invo setArgument:&p4 atIndex:5];
        }
        if (p5) {
            [invo setArgument:&p5 atIndex:6];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        if (p3) {
            [invo setArgument:&p3 atIndex:4];
        }
        if (p4) {
            [invo setArgument:&p4 atIndex:5];
        }
        if (p5) {
            [invo setArgument:&p5 atIndex:6];
        }
        if (p6) {
            [invo setArgument:&p6 atIndex:7];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)ot_utPerformSelector:(SEL)selector
                withObject:(id)p1
                withObject:(id)p2
                withObject:(id)p3
                withObject:(id)p4
                withObject:(id)p5
                withObject:(id)p6
                withObject:(id)p7 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        if (p1) {
            [invo setArgument:&p1 atIndex:2];
        }
        if (p2) {
            [invo setArgument:&p2 atIndex:3];
        }
        if (p3) {
            [invo setArgument:&p3 atIndex:4];
        }
        if (p4) {
            [invo setArgument:&p4 atIndex:5];
        }
        if (p5) {
            [invo setArgument:&p5 atIndex:6];
        }
        if (p6) {
            [invo setArgument:&p6 atIndex:7];
        }
        if (p7) {
            [invo setArgument:&p7 atIndex:8];
        }

        [invo invoke];
        return [self ot_utGetReturnValue:invo];
    } else {
        return nil;
    }
}

@end
