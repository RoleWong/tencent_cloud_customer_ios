//
//  OTSpanProccessor.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanProcessor.h"

#import "OTResource.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_PROCESSOR
#import "OTSpanProcessorImp.h"
#endif

@interface OTSpanProcessor()

#ifdef OT_TRACING_SDK_PROCESSOR

@property (nonatomic, strong) OTSpanProcessorImp *impObject;

#endif

@end

@implementation OTSpanProcessor

- (OTExporterCallback)onSpanReportedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.onSpanReportedCallback;
#else
    return nil;
#endif
}

- (void)setOnSpanReportedCallback:(OTExporterCallback)onSpanReportedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.onSpanReportedCallback = onSpanReportedCallback;
#endif
}

- (OTSpanStartedBlock)onSpanStartedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.onSpanStartedCallback;
#else
    return nil;
#endif
}

- (void)setOnSpanStartedCallback:(OTSpanStartedBlock)onSpanStartedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.onSpanStartedCallback = onSpanStartedCallback;
#endif
}

- (OTSpanEndedBlock)onSpanEndedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.onSpanEndedCallback;
#else
    return nil;
#endif
}

- (void)setOnSpanEndedCallback:(OTSpanEndedBlock)onSpanEndedCallback {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.onSpanEndedCallback = onSpanEndedCallback;
#endif
}

- (NSUInteger)maxQueueSize {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.maxQueueSize;
#else
    return 0;
#endif
}

- (void)setMaxQueueSize:(NSUInteger)maxQueueSize {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.maxQueueSize = maxQueueSize;
#else
#endif
}

- (NSTimeInterval)processInterval {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.processInterval;
#else
    return 0;
#endif
}

- (void)setProcessInterval:(NSTimeInterval)processInterval {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.processInterval = processInterval;
#else
#endif
}

- (NSUInteger)maxExportBatchSize {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.maxExportBatchSize;
#else
    return 0;
#endif
}

- (void)setMaxExportBatchSize:(NSUInteger)maxExportBatchSize {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.maxExportBatchSize = maxExportBatchSize;
#else
#endif
}

- (id<OTSpanExporterProtocol>)exporter {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.exporter;
#else
    return nil;
#endif
}

- (void)setExporter:(id<OTSpanExporterProtocol>)exporter {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.exporter = exporter;
#else
#endif
}

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_TRACING_SDK_PROCESSOR
        _impObject = [[OTSpanProcessorImp alloc] init];
#endif
    }
    return self;
}

- (void)forceFlush {
#ifdef OT_TRACING_SDK_PROCESSOR
    return [self.impObject forceFlush];
#endif
}

- (void)onEnd:(nonnull OTSpan *)span {
#ifdef OT_TRACING_SDK_PROCESSOR
    return [self.impObject onEnd:span];
#endif
}

- (void)onStart:(nonnull OTSpan *)span {
#ifdef OT_TRACING_SDK_PROCESSOR
    return [self.impObject onStart:span];
#endif
}

- (void)shutdown {
#ifdef OT_TRACING_SDK_PROCESSOR
    return [self.impObject shutdown];
#endif
}

- (OTResource *)resource {
#ifdef OT_TRACING_SDK_PROCESSOR
    return self.impObject.resource;
#else
    return nil;
#endif
}

- (void)setResource:(OTResource *)resource {
#ifdef OT_TRACING_SDK_PROCESSOR
    self.impObject.resource = resource;
#endif
}

@end
