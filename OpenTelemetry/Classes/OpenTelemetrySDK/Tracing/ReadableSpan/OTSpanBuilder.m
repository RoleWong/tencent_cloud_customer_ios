//
//  OTSpanBuilder.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanBuilder.h"
#import "OTTraceFlags.h"
#import "OTSpanContext.h"
#import "OTSpanKind.h"
#import "OTLink.h"
#import "OTReadableSpan.h"
#import "OTTraceState.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTAttributesWithCapacity.h"
#import "OTAttribute.h"
#import "OTSampler.h"
#import "OTTracer.h"
#import "OTRandomIdsGenerator.h"
#import "OTReadableSpan+Private.h"
#import "OTSpan+Private.h"

@interface OTSpanBuilder ()

/// the building name of the span
@property (nonatomic, copy) NSString *spanName;
/// the tracer who calls the span creation
@property (nonatomic, strong) OTTracer *tracer;
/// the parent span
@property (nonatomic, strong) OTSpan *parent;
/// the parent's context of the span
@property (nonatomic, strong) OTSpanContext *parentContext;
/// Clock to recorad span start and end time
@property (nonatomic, strong) id<OTClockProtocol> clock;
/// Id generator responseble for generating spanId and trace Id when needed
@property (nonatomic, strong) id<OTIdsGenerator> idGenerator;

@property (nonatomic, strong) id<OTSpanBizDecoratorProtocol> bizDecorator;
@end

@implementation OTSpanBuilder

- (instancetype)initWithSpanName:(NSString *)spanName tracer:(OTTracer *)tracer {
    if (self = [super init]) {
        _spanName = spanName;
        _tracer = tracer;
    }
    return self;
}

#pragma mark - Getter & Setter

- (id<OTIdsGenerator>)idGenerator {
    if (!_idGenerator) {
        _idGenerator = [[OTRandomIdsGenerator alloc] init];
    }
    return _idGenerator;
}

- (id<OTClockProtocol>)clock {
    if (!_clock) {
        _clock = [[OTClock alloc] init];
    }
    return _clock;
}

#pragma mark - Public

- (void)configParentSpan:(OTSpan *)parentSpan {
    self.parent = parentSpan;
    self.parentContext = nil;
}

- (void)configDefaultParent {
    self.parent = [self.tracer currentActiveSpan];
    self.parentContext = nil;
}

- (void)configParentContext:(OTSpanContext *)parentContext {
    self.parentContext = parentContext;
    self.parent = nil;
}

- (void)configNoParent {
    self.parentContext = nil;
    self.parent = nil;
}

- (void)configClock:(id<OTClockProtocol>)clock {
    self.clock = clock;
}

- (void)configBizDecorator:(id<OTSpanBizDecoratorProtocol>)bizDecorator {
    self.bizDecorator = bizDecorator;
}

- (void)configIdGenerator:(id<OTIdsGenerator>)idGenerator {
    self.idGenerator = idGenerator;
}

- (OTSpanContext *)extractParentContext {
    OTSpanContext *parentContext = nil;
    if (self.parent || parentContext.isValid) {
        parentContext = _parent.context;
    } else if (self.parentContext) {
        parentContext = self.parentContext;
    }
    return parentContext;
}

- (OTSpan *)buildSpan {
    OTSpanId *spanid = [self.idGenerator generateSpanId];
    OTTraceId *traceId = nil;
    OTTraceState *traceState = nil;
    OTSpanContext *parentContext = [self extractParentContext];
    if (parentContext.isValid) {
        // if a parent span id is valid, inherit its context
        traceId = parentContext.traceId;
        traceState = parentContext.traceState;
    } else {
        // if no valid parent span id, create a root span
        traceId = [self.idGenerator generateTraceId];
        traceState = [[OTTraceState alloc] initWithAttributes:@[]];
    }
    OTSpanContext *spanContext = [OTSpanContext spanContextWithTraceId:traceId spanId:spanid traceState:traceState remote:NO];
    OTReadableSpan *span = [[OTReadableSpan alloc] initWithContext:spanContext name:self.spanName];
    span.parentSpanContext = parentContext;
    span.clock = self.clock;
    span.libraryInfo = self.tracer.instrumentationLibraryInfo;
    span.maximumAttributes = self.tracer.maxNumberOfAttributes;
    span.maximumLinks = self.tracer.maxNumberOfLinks;
    span.maximumAttributesPerLink = self.tracer.maxNumberOfAttributesPerLink;
    span.maximumEvents = self.tracer.maxNumberOfEvents;
    span.maximumAttributesPerEvent = self.tracer.maxNumberOfAttributesPerEvent;
    span.delegate = self.tracer;
    if ([self.bizDecorator respondsToSelector:@selector(spanKind)]) {
        span.kind = [self.bizDecorator spanKind];
    } else {
        span.kind = SpanKindClient;
    }
    if ([self.bizDecorator respondsToSelector:@selector(startEpochNanos)]) {
        [span startSpanWithTimestamp:[self.bizDecorator startEpochNanos]];
    } else {
        [span startSpan];
    }
    return span;
}

@end
