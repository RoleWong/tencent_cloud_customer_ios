//
//  OTSpan+Private.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpan+Private.h"
#import "OTSpanProxy.h"
#import <objc/runtime.h>

@implementation OTSpan (Private)

@dynamic endedRecursively;
@dynamic parentSpanContext;
@dynamic libraryInfo;
@dynamic kind;
@dynamic context;
@dynamic name;
@dynamic status;
@dynamic recording;

- (id<OTSpanDelegate>)delegate {
    OTSpanProxy *proxy = objc_getAssociatedObject(self, "delegate");
    return proxy;
}

- (void)setDelegate:(id<OTSpanDelegate>)delegate {
    OTSpanProxy *proxy = [[OTSpanProxy alloc] initWithTarget:delegate];
    objc_setAssociatedObject(self, "delegate", proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
