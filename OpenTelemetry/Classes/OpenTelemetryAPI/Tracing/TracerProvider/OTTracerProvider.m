//
//  OTTracerProvider.m
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2020/8/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTracerProvider.h"
#import "OTTracer.h"
#import "OTResource.h"
#import "OTSafeDictionary.h"
#import "OTSpanContext.h"
#import "OTTraceFlags.h"
#import "OTSampler.h"
#import "OTSpanProcessor.h"

NSString *const gInstrumentationLibraryName = @"OpenTelemetryInstrumentation";

NSString *const gOpenTelemeteryVersion = @"1.0.69";

static char *const gTracerProviderHandleQueue = "gTracerProviderHandleQueue";

@interface OTTracerProvider () {
    dispatch_queue_t _tracerProviderHandleQueue;
}

/// all stashed span processors
@property (nonatomic, strong) OTSafeDictionary<NSString *, id<OTSpanProcessorProtocol>> *processors;
/// all stashed span samplers
@property (nonatomic, strong) OTSafeDictionary<NSString *, id<OTSamplerProtocol>> *samplers;
/// all stashed tracer
@property (nonatomic, strong) OTSafeDictionary *tracers;
/// current tracer's info
@property (nonatomic, strong) OTInstrumentationLibraryInfo *currentTracerInfo;
/// lock in order to keep multithread safe
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

/// OpenTelemetry的API入口
@implementation OTTracerProvider

@synthesize spanInstancesLimit = _spanInstancesLimit;

- (NSUInteger)spanInstancesLimit {
    NSUInteger result = 0;
    [self.lock lock];
    result = _spanInstancesLimit;
    [self.lock unlock];
    return result;
}

- (void)setSpanInstancesLimit:(NSUInteger)spanInstancesLimit {
    [self.lock lock];
    _spanInstancesLimit = spanInstancesLimit;
    [self.lock unlock];
}

- (void)dealloc {
    _lock = nil;
}

- (instancetype)initWithResource:(OTResource *)resource {
    if (self = [super init]) {
        _resource = resource;
        _tracers = [[OTSafeDictionary alloc] init];
        _processors = [[OTSafeDictionary alloc] init];
        _samplers = [[OTSafeDictionary alloc] init];
        _tracerProviderHandleQueue = dispatch_queue_create(gTracerProviderHandleQueue, DISPATCH_QUEUE_SERIAL);
        _lock = [[NSRecursiveLock alloc] init];
        // default sampler
        OTSampler *sampler = [[OTSampler alloc] init];
        sampler.samplingRate = 1;
        self.spanInstancesLimit = 1024;
        [self registerSampler:sampler forKey:@"defaultSampler"];
        // default processor
        OTSpanProcessor *processor = [[OTSpanProcessor alloc] init];
        processor.processInterval = 3000;
        [self registerSpanProcessor:processor forKey:@"defaultProcessor"];
    }
    return self;
}

- (instancetype)init {
    return [self initWithResource:nil];
}

- (id<OTTracerProtocol>)currentTracer {
    id<OTTracerProtocol> tracer = nil;
    [self.lock lock];
    NSString *libraryName = [self.currentTracerInfo.name copy];
    NSString *version = [self.currentTracerInfo.version copy];
    [self.lock unlock];
    if (libraryName.length > 0 && version.length > 0) {
        tracer = [self tracerWithInstrumentationName:libraryName version:version];
    }
    return tracer;
}

- (NSString *)traceBaggageSerializedString {
    return @"";
}

#pragma mark - Processor

- (void)registerSpanProcessor:(id<OTSpanProcessorProtocol>)processor forKey:(NSString *)key {
    processor.resource = self.resource;
    [self.processors setObject:processor forKey:key];
}

- (id<OTSpanProcessorProtocol>)spanProessorForKey:(NSString *)key {
    id<OTSpanProcessorProtocol> processor = [self.processors objectForKey:key];
    return processor;
}

- (id<OTSpanProcessorProtocol>)defaultSpanProcessor {
    return [self spanProessorForKey:@"defaultProcessor"];
}

- (void)removeSpanProcessorForKey:(NSString *)key {
    [self.processors removeObjectForKey:key];
}

- (NSArray<id<OTSpanProcessorProtocol>> *)processorsList {
    NSArray *processorList = [self.processors allValues];
    return processorList;
}

/// Called when a span was started
/// @param span span
- (void)onStart:(OTSpan *)span {
    // when span was created, iterate every processor registered in provider to call on start method
    [self.processorsList enumerateObjectsUsingBlock:^(id<OTSpanProcessorProtocol> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj onStart:span];
    }];
    // after on start process, iterate every sampler registered in provider to get sampling decesion.
    [self.samplers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTSamplerProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        OTSamplerDesicion *desicion = [obj shouldSampleSpanWithName:span.name
                                                               kind:span.kind
                                                             parent:span.context
                                                         attributes:span.attributes
                                                              links:span.links];
        if (desicion.isSampled) {
            span.context.traceFlags = [[[OTTraceFlags alloc] init] settingSampled:desicion.isSampled];
            return;
        }
    }];
}

/// Called when a span was ended
/// @param span span
- (void)onEnd:(OTSpan *)span {
    [self.processorsList enumerateObjectsUsingBlock:^(id<OTSpanProcessorProtocol> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj onEnd:span];
    }];
}

#pragma mark - Sampler

- (void)registerSampler:(id<OTSamplerProtocol>)sampler forKey:(NSString *)key {
    [self.samplers setObject:sampler forKey:key];
}

- (id<OTSamplerProtocol>)samplerForKey:(NSString *)key {
    id<OTSamplerProtocol> sampler = [self.samplers objectForKey:key];
    return sampler;
}

- (id<OTSamplerProtocol>)defaultSampler {
    return [self samplerForKey:@"defaultSampler"];
}

- (void)removeSamplerForKey:(NSString *)key {
    [self.samplers removeObjectForKey:key];
}

- (NSArray<id<OTSamplerProtocol>> *)samplerList {
    NSArray *samplerList = [self.samplers allValues];
    return samplerList;
}

#pragma mark - TracerProvider

- (void)shutdown {
    [self.processorsList enumerateObjectsUsingBlock:^(id<OTSpanProcessorProtocol> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj shutdown];
    }];
}

- (void)forceFlush {
    [self.processorsList enumerateObjectsUsingBlock:^(id<OTSpanProcessorProtocol> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj forceFlush];
    }];
}

- (id<OTTracerProtocol>)tracerWithInstrumentationName:(NSString *)name version:(NSString *)version {
    __block OTTracer *tracer = nil;
    OTInstrumentationLibraryInfo *info = [[OTInstrumentationLibraryInfo alloc] initWithName:name version:version];
    dispatch_sync(_tracerProviderHandleQueue, ^{
        NSString *infoKey = info.key;
        tracer = [self.tracers objectForKey:infoKey];
        if (!tracer) {
            tracer = [[OTTracer alloc] initWithInfo:info];
            tracer.active = YES;
            tracer.provider = self;
            [self.tracers setValue:tracer forKey:infoKey];
        }
    });
    if (tracer) {
        [self.lock lock];
        self.currentTracerInfo = info;
        [self.lock unlock];
    }
    return tracer;
}

- (void)updateDefaultSpanSampler:(nonnull id<OTSamplerProtocol>)sampler {
    [self registerSampler:sampler forKey:@"defaultSampler"];
}

@end
