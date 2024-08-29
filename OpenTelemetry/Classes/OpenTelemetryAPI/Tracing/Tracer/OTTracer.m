//
//  Tracer.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/4/30.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTracer.h"
#import "OTSpanContext.h"
#import "OTSpanId.h"
#import "OTTracerProvider.h"
#import "OTSafeDictionary.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_SPAN
#import "OTSpanBuilder.h"
#endif

static char *const gTracerHandleQueue = "gTracerHandleQueue";

@interface OTTracer () {
    dispatch_queue_t _tracerHandleQueue; // 处理Tracer的队列
    NSRecursiveLock *_lock;              // thread lock that manage spanContextMap
}

@property (nonatomic, strong) OTInstrumentationLibraryInfo *instrumentationLibraryInfo;

@property (nonatomic, strong) OTSafeDictionary *contextMap;

@property (nonatomic, copy) NSString *activeSpanId;

@end

@implementation OTTracer

- (void)dealloc {
    _lock = nil;
}

- (instancetype)initWithInfo:(OTInstrumentationLibraryInfo *)instrumentationLibraryInfo {
    if (self = [super init]) {
        _instrumentationLibraryInfo = instrumentationLibraryInfo;
        _tracerHandleQueue = dispatch_queue_create(gTracerHandleQueue, DISPATCH_QUEUE_SERIAL);
        _contextMap = [[OTSafeDictionary alloc] init];
        _lock = [[NSRecursiveLock alloc] init];
        _maxNumberOfLinks = 128;
        _maxNumberOfEvents = 128;
        _maxNumberOfAttributes = 128;
        _maxNumberOfAttributesPerLink = 128;
        _maxNumberOfAttributesPerEvent = 128;
    }
    return self;
}

#pragma mark - Getter & Setter

- (void)setMaxNumberOfLinks:(NSInteger)maxNumberOfLinks {
    if (maxNumberOfLinks < 0) {
        _maxNumberOfLinks = 0;
    } else {
        _maxNumberOfLinks = maxNumberOfLinks;
    }
}

- (void)setMaxNumberOfEvents:(NSInteger)maxNumberOfEvents {
    if (maxNumberOfEvents < 0) {
        _maxNumberOfEvents = 0;
    } else {
        _maxNumberOfEvents = maxNumberOfEvents;
    }
}

- (void)setMaxNumberOfAttributes:(NSInteger)maxNumberOfAttributes {
    if (maxNumberOfAttributes < 0) {
        _maxNumberOfAttributes = 0;
    } else {
        _maxNumberOfAttributes = maxNumberOfAttributes;
    }
}

- (void)setMaxNumberOfAttributesPerLink:(NSInteger)maxNumberOfAttributesPerLink {
    if (_maxNumberOfAttributesPerLink < 0) {
        _maxNumberOfAttributesPerLink = 0;
    } else {
        _maxNumberOfAttributesPerLink = maxNumberOfAttributesPerLink;
    }
}

- (void)setMaxNumberOfAttributesPerEvent:(NSInteger)maxNumberOfAttributesPerEvent {
    if (_maxNumberOfAttributesPerEvent < 0) {
        _maxNumberOfAttributesPerEvent = 0;
    } else {
        _maxNumberOfAttributesPerEvent = maxNumberOfAttributesPerEvent;
    }
}

#ifdef OT_TRACING_SDK_SPAN
- (OTSpanBuilder *)spanBuilderWithSpanName:(NSString *)spanName bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator {
    if (self.provider.spanInstancesLimit < self.contextMap.count) {
        return nil;
    }
    OTSpanBuilder *builder = [[OTSpanBuilder alloc] initWithSpanName:spanName tracer:self];
    [builder configClock:self.clock];
    [builder configIdGenerator:self.idGenerator];
    [builder configBizDecorator:bizDecorator];
    return builder;
}
#endif

- (OTSpan *)spanWithName:(NSString *)name {
    return [self spanWithName:name bizDecorator:nil];
}

- (OTSpan *)spanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator {
#ifdef OT_TRACING_SDK_SPAN
    __block OTSpan *span = nil;
    dispatch_sync(_tracerHandleQueue, ^{
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configDefaultParent];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
    });
    return span;
#else
    return [[OTSpan alloc] init];
#endif
}

- (void)asyncSpanWithName:(NSString *)name completion:(OTSpanCreationBlock)completion {
    [self asyncSpanWithName:name bizDecorator:nil completion:completion];
}

- (void)asyncSpanWithName:(NSString *)name
                     bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
               completion:(OTSpanCreationBlock)completion {
#ifdef OT_TRACING_SDK_SPAN
    dispatch_async(_tracerHandleQueue, ^{
        OTSpan *span = nil;
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configDefaultParent];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
        if (completion) {
            completion(span);
        }
    });
#else
    if (completion) {
        completion(nil);
    }
#endif
}

- (OTSpan *)spanWithName:(NSString *)name
                  parent:(OTSpan *)parentSpan {
    return [self spanWithName:name bizDecorator:nil parent:parentSpan];
}

- (OTSpan *)spanWithName:(NSString *)name
                    bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
                  parent:(OTSpan *)parentSpan {
#ifdef OT_TRACING_SDK_SPAN
    __block OTSpan *span = nil;
    dispatch_sync(_tracerHandleQueue, ^{
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configParentSpan:parentSpan];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
    });
    return span;
#else
    return [[OTSpan alloc] init];
#endif
}

- (void)asyncSpanWithName:(NSString *)name
                   parent:(OTSpan *)parentSpan
               completion:(OTSpanCreationBlock)completion {
    [self asyncSpanWithName:name bizDecorator:nil parent:parentSpan completion:completion];
}

- (void)asyncSpanWithName:(NSString *)name
                     bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
                   parent:(OTSpan *)parentSpan
               completion:(OTSpanCreationBlock)completion {
#ifdef OT_TRACING_SDK_SPAN
    dispatch_async(_tracerHandleQueue, ^{
        OTSpan *span = nil;
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configParentSpan:parentSpan];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
        if (completion) {
            completion(span);
        }
    });
#else
    if (completion) {
        completion(nil);
    }
#endif
}

- (OTSpan *)spanWithName:(NSString *)name context:(OTSpanContext *)remoteSpanContext {
    return [self spanWithName:name bizDecorator:nil context:remoteSpanContext];
}

- (OTSpan *)spanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator context:(OTSpanContext *)remoteSpanContext {
#ifdef OT_TRACING_SDK_SPAN
    __block OTSpan *span = nil;
    dispatch_sync(_tracerHandleQueue, ^{
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configParentContext:remoteSpanContext];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
    });
    return span;
#else
    return [[OTSpan alloc] init];
#endif
}

- (void)asyncSpanWithName:(NSString *)name context:(OTSpanContext *)remoteSpanContext completion:(OTSpanCreationBlock)completion {
    [self asyncSpanWithName:name bizDecorator:nil context:remoteSpanContext completion:completion];
}

- (void)asyncSpanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator context:(OTSpanContext *)remoteSpanContext completion:(OTSpanCreationBlock)completion {
#ifdef OT_TRACING_SDK_SPAN
    dispatch_async(_tracerHandleQueue, ^{
        OTSpan *span = nil;
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configParentContext:remoteSpanContext];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
        if (completion) {
            completion(span);
        }
    });
#else
    if (completion) {
        completion(nil);
    }
#endif
}

- (OTSpan *)rootSpanWithName:(NSString *)name {
    return [self rootSpanWithName:name bizDecorator:nil];
}
- (OTSpan *)rootSpanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator {
#ifdef OT_TRACING_SDK_SPAN
    __block OTSpan *span = nil;
    if (name.length == 0) {
        return span;
    }
    dispatch_sync(_tracerHandleQueue, ^{
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configNoParent];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
    });
    return span;
#else
    return [[OTSpan alloc] init];
#endif
}

- (void)asyncRootSpanWithName:(NSString *)name
                   completion:(OTSpanCreationBlock)completion {
    [self asyncRootSpanWithName:name bizDecorator:nil completion:completion];
}

- (void)asyncRootSpanWithName:(NSString *)name
                         bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
                   completion:(OTSpanCreationBlock)completion {
#ifdef OT_TRACING_SDK_SPAN
    dispatch_async(_tracerHandleQueue, ^{
        OTSpan *span = nil;
        OTSpanBuilder *builder = [self spanBuilderWithSpanName:name bizDecorator:bizDecorator];
        [builder configNoParent];
        span = [builder buildSpan];
        if (self.isActive) {
            [self markActiveSpanId:span.context.spanIdString];
        }
        if (completion) {
            completion(span);
        }
    });
#else
    if (completion) {
        completion(nil);
    }
#endif
}

#pragma mark - ContextCache

- (void)markActiveSpanId:(NSString *)spanId {
    OTSpan *tempSpan = [self.contextMap objectForKey:spanId];
    if (!tempSpan) {
        return;
    }
    [_lock lock];
    self.activeSpanId = spanId;
    [_lock unlock];
}

- (void)stashToContextWithSpan:(OTSpan *)span spanId:(NSString *)spanId {
    [self.contextMap setValue:span forKey:spanId];
}

- (void)removeFromContextWithSpan:(NSString *)spanId {
    OTSpan *tempSpan = [self.contextMap objectForKey:spanId];
    if (tempSpan) {
        [self.contextMap removeObjectForKey:spanId];
    }
}

- (OTSpan *)currentActiveSpan {
    NSString *spanId = @"";
    [_lock lock];
    spanId = [self.activeSpanId copy];
    [_lock unlock];
    return [self spanCachedBySpanId:spanId];
}

- (OTSpan *)spanCachedBySpanId:(NSString *)spanId {
    [_lock lock];
    OTSpan *cachedSpan = [self.contextMap objectForKey:spanId];
    [_lock unlock];
    return cachedSpan;
}

- (OTSpan *)spanCachedBySpanContext:(id<OTContextProtocol>)spanContext {
    return [self spanCachedBySpanId:spanContext.spanIdString];
}

- (OTSpan *)spanCachedBySpanContextString:(NSString *)spanContextString {
    OTSpanContext *context = [OTSpanContext spanContextWithTraceParent:spanContextString];
    return [self spanCachedBySpanId:context.spanIdString];
}

#pragma mark - OTSpanDisposalProtocol

- (void)span:(OTSpan *)span didStartedWithSpanId:(NSString *)spanId {
    [self.provider onStart:span];
    [self stashToContextWithSpan:span spanId:span.context.spanId.hexString];
}

- (void)span:(OTSpan *)span didEndedWithSpanId:(NSString *)spanId {
    [self.provider onEnd:span];
    [self removeFromContextWithSpan:spanId];
    if (span.isEndedRecursively) {
        OTSpan *parentSpan = [self spanCachedBySpanId:span.parentSpanContext.spanIdString];
        [parentSpan endRecursively];
    }
}

- (OTSpan *_Nullable)parentSpanForSpan:(OTSpan *)span {
    return [self spanCachedBySpanId:span.parentSpanContext.spanIdString];
}

@end
