//
//  OTSpanContext.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanContext.h"

#import "OTTraceState.h"
#import "OTTraceId.h"
#import "OTSpanId.h"
#import "OTTraceFlags.h"

@interface OTSpanContext ()

/// 踪迹的Id
@property (nonatomic, strong) OTTraceId *traceId;

/// SpanId
@property (nonatomic, strong) OTSpanId *spanId;

/// 踪迹状态
@property (nonatomic, strong) OTTraceState *traceState;

/// 是否远端Span
@property (nonatomic, assign) BOOL remote;

@end

@implementation OTSpanContext

static NSString *const kHeaderVersion = @"00";

/// 组成TraceParent的元素总数
static NSUInteger const gTraceParentComponentsCount = 4;
/// 提取TraceId的下标位置
static NSUInteger const gTraceIdIndex = 1;
/// 提取SpanId的下标位置
static NSUInteger const gSpanIdIndex = 2;
/// 提取染色决定的下标位置
static NSUInteger const gIsSampledIndex = 3;

- (instancetype)initWithTraceId:(OTTraceId *)traceId
                         spanId:(OTSpanId *)spanId
                     traceState:(OTTraceState *)traceState
                         remote:(BOOL)isRemote {
    if (self = [super init]) {
        _traceId = traceId;
        _spanId = spanId;
        _traceState = traceState;
        _remote = isRemote;
    }
    return self;
}

+ (instancetype)spanContextWithTraceId:(OTTraceId *)traceId
                                spanId:(OTSpanId *)spanId
                            traceState:(OTTraceState *)traceState
                                remote:(BOOL)isRemote {
    OTSpanContext *context = [[self alloc] initWithTraceId:traceId spanId:spanId traceState:traceState remote:isRemote];
    return context;
}

+ (instancetype)spanContextWithTraceParent:(NSString *)traceParentSerialization {
    return [self spanContextWithTraceParent:traceParentSerialization traceState:nil];
}

+ (instancetype)spanContextWithTraceParent:(NSString *)traceParentSerialization traceState:(NSString *)traceStateSerialization {
    NSArray *components = [traceParentSerialization componentsSeparatedByString:@"-"];
    if (components.count != gTraceParentComponentsCount) {
        return nil;
    }
    NSString *traceIdString = components[gTraceIdIndex];
    NSString *spanIdString = components[gSpanIdIndex];
    NSString *isSampled = components[gIsSampledIndex];

    OTTraceFlags *flags = [[[OTTraceFlags alloc] init] settingSampled:isSampled.boolValue];
    OTTraceId *traceId = [[OTTraceId alloc] initWithHexString:traceIdString];
    OTSpanId *spanId = [[OTSpanId alloc] initWithHexString:spanIdString];
    OTTraceState *state = nil;
    if (traceStateSerialization) {
        state = [[OTTraceState alloc] initWithSerialization:traceParentSerialization];
    } else {
        state = [[OTTraceState alloc] initWithAttributes:@[]];
    }
    OTSpanContext *context = [OTSpanContext spanContextWithTraceId:traceId spanId:spanId traceState:state remote:YES];
    context.traceFlags = flags;
    return context;
}

- (BOOL)isValid {
    return self.traceId.isValid && self.spanId.isValid;
}

- (BOOL)inSameTraceWithContext:(OTSpanContext *)context {
    BOOL sameTraceId = [self.traceId isEqualToTraceId:context.traceId];
    BOOL sameTraceFlag = [self.traceFlags isEqualToTraceFlag:context.traceFlags];
    return sameTraceId && sameTraceFlag;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SpanConetxt[TraceId = %@, SpanId = %@, traceFlags = %@, isRemote: %d]", self.traceId.description,
                                      self.spanId.description, self.traceFlags.description, self.isRemote];
}

- (NSString *)serializationString {
    NSString *traceId = self.traceId.hexString;
    NSString *spanId = self.spanId.hexString;
    BOOL isSampled = self.traceFlags.isSampled;
    return [NSString stringWithFormat:@"%@-%@-%@-0%d", kHeaderVersion, traceId, spanId, isSampled];
}

- (NSString *)traceIdString {
    return self.traceId.hexString;
}

- (NSString *)spanIdString {
    return self.spanId.hexString;
}

- (NSData *)traceIdByte {
    NSString *traceIdString = self.traceId.hexString;
    return [traceIdString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)spanIdByte {
    NSString *spanIdString = self.spanId.hexString;
    return [spanIdString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)traceParentString {
    return [self serializationString];
}

- (NSString *)traceStateString {
    return [self.traceState serializationString];
}

- (BOOL)isSampled {
    return self.traceFlags.isSampled;
}

@end
