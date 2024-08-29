//
//  OTBaseObject.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#include <objc/runtime.h>

@implementation OTBaseObject

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = [self class];
    while (cls != [NSObject class]) {
        unsigned int numberOfIvars = 0;
        Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);
        for (const Ivar *p = ivars; p < ivars + numberOfIvars; p++) {
            Ivar const ivar = *p;
            const char *type = ivar_getTypeEncoding(ivar);
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if (key == nil) {
                continue;
            }
            if ([key length] == 0) {
                continue;
            }
            id value = [self valueForKey:key];
            if (value) {
                switch (type[0]) {
                    case _C_STRUCT_B: {
                        NSUInteger ivarSize = 0;
                        NSUInteger ivarAlignment = 0;
                        NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                        NSData *data = [NSData dataWithBytes:(const char *)((__bridge void *)self) + ivar_getOffset(ivar) length:ivarSize];
                        [encoder encodeObject:data forKey:key];
                    } break;
                    default:
                        [encoder encodeObject:value forKey:key];
                        break;
                }
            }
        }
        if (ivars) {
            free(ivars);
        }

        cls = class_getSuperclass(cls);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];

    if (self) {
        Class cls = [self class];
        while (cls != [NSObject class]) {
            unsigned int numberOfIvars = 0;
            Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);

            for (const Ivar *p = ivars; p < ivars + numberOfIvars; p++) {
                Ivar const ivar = *p;
                const char *type = ivar_getTypeEncoding(ivar);
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                if (key == nil) {
                    continue;
                }
                if ([key length] == 0) {
                    continue;
                }
                id value = [decoder decodeObjectForKey:key];
                if (value) {
                    switch (type[0]) {
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize = 0;
                            NSUInteger ivarAlignment = 0;
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            NSData *data = [decoder decodeObjectForKey:key];
                            char *sourceIvarLocation = (char *)((__bridge void *)self) + ivar_getOffset(ivar);
                            [data getBytes:sourceIvarLocation length:ivarSize];
                            memcpy((char *)((__bridge void *)self) + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
                        } break;
                        default:
                            [self setValue:value forKey:key];
                            break;
                    }
                }
            }

            if (ivars) {
                free(ivars);
            }
            cls = class_getSuperclass(cls);
        }
    }

    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NSData *valueData = nil;
    NSError *archiveError = nil;
    if (@available(iOS 11.0, *)) {
        valueData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:&archiveError];
        NSSet *classSet = [NSSet setWithObjects:self.class, NSNumber.class, NSString.class, nil];
        id newModel = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:valueData error:&archiveError];
        if ([newModel isKindOfClass:self.class]) {
            return newModel;
        }
    } else {
        // Fallback on earlier versions
        valueData = [NSKeyedArchiver archivedDataWithRootObject:self];
        id newModel = [NSKeyedUnarchiver unarchiveObjectWithData:valueData];
        if ([newModel isKindOfClass:self.class]) {
            return newModel;
        }
    }
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
