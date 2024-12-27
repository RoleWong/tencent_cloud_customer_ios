//
//  OTReadableSpan+Private.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/2.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTReadableSpan+Private.h"
#import <objc/runtime.h>

@implementation OTReadableSpan (Private)

- (id<OTClockProtocol>)clock {
    return objc_getAssociatedObject(self, "clock");
}

- (void)setClock:(id<OTClockProtocol>)clock {
    objc_setAssociatedObject(self, "clock", clock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
