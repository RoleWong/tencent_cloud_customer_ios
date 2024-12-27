//
//  OTLoggingRecord+Private.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/2.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTLoggingRecord+Private.h"
#import "OTClock.h"
#import <objc/runtime.h>

@implementation OTLoggingRecord (Private)

- (id<OTClockProtocol>)clock {
    id clock = objc_getAssociatedObject(self, "clock");
    if (!clock) {
        clock = [[OTClock alloc] init];
        [self setClock:clock];
    }
    return clock;
}

- (void)setClock:(id<OTClockProtocol>)clock {
    objc_setAssociatedObject(self, "clock", clock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
