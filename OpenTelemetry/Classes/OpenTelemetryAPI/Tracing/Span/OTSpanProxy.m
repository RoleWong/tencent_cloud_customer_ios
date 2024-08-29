//
//  OTSpanProxy.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/2.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpanProxy.h"
#import "OTSpan+Private.h"
#import <objc/runtime.h>

@interface OTSpanProxy ()

@property (nonatomic, weak) NSObject<OTSpanDelegate> *delegate;

@end

@implementation OTSpanProxy

- (instancetype)initWithTarget:(id<OTSpanDelegate>)target {
    _delegate = target;
    return self;
}

- (void)span:(nonnull OTSpan *)span didEndedWithSpanId:(nonnull NSString *)spanId {
    [self.delegate span:span didEndedWithSpanId:spanId];
}

- (void)span:(nonnull OTSpan *)span didStartedWithSpanId:(nonnull NSString *)spanId {
    [self.delegate span:span didStartedWithSpanId:spanId];
}

- (OTSpan *_Nullable)parentSpanForSpan:(OTSpan *)span {
    return [self.delegate parentSpanForSpan:span];
}

@end
