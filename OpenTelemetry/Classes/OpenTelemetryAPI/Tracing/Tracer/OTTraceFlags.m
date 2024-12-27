//
//  OTTraceFlags.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTraceFlags.h"

@interface OTTraceFlags ()

@property (nonatomic, assign) uint8_t options;

@end

@implementation OTTraceFlags

static uint8_t gIsSampled = 0x1; // 判断是否被取样的标识符

- (instancetype)initWithByte:(UInt8)byte {
    self = [super init];
    if (self) {
        _options = byte;
    }
    return self;
}

- (BOOL)isSampled {
    return (self.options & gIsSampled) != 0;
}

- (void)setSampled:(BOOL)sampled {
    if (sampled) {
        _options = (_options | gIsSampled);
    } else {
        _options = (_options & ~gIsSampled);
    }
}

- (instancetype)settingSampled:(BOOL)sampled {
    UInt8 sampledByte = 0;

    if (sampled) {
        sampledByte = (_options | gIsSampled);
    } else {
        sampledByte = (_options & ~gIsSampled);
    }
    OTTraceFlags *newTraceFlag = [[OTTraceFlags alloc] initWithByte:sampledByte];
    return newTraceFlag;
}

- (NSString *)hexString {
    return [NSString stringWithFormat:@"%02x", self.options];
}

- (BOOL)isEqualToTraceFlag:(OTTraceFlags *)traceFlag {
    return [self.hexString isEqualToString:traceFlag.hexString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TraceFlags(sampled = %d)", self.isSampled];
}

@end
