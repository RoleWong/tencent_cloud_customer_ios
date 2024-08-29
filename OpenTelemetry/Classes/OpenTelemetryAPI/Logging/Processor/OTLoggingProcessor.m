//
//  OTLoggingProcessor.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingProcessor.h"
#import "OTLoggingRecord.h"
#import "OTDependencyDefine.h"
#ifdef OT_LOGGING_SDK_PROCESSOR
#import "OTLoggingProcessorImp.h"
#endif

@interface OTLoggingProcessor ()
#ifdef OT_LOGGING_SDK_PROCESSOR
@property (nonatomic, strong) OTLoggingProcessorImp *impObject;
#endif
@end

@implementation OTLoggingProcessor

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_LOGGING_SDK_PROCESSOR
        _impObject = [[OTLoggingProcessorImp alloc] init];
#endif
    }
    return self;
}

- (void)addLogRecord:(OTLoggingRecord *)logRecord {
#ifdef OT_LOGGING_SDK_PROCESSOR
    [self.impObject addLogRecord:logRecord];
#endif
}

- (void)shutdown {
#ifdef OT_LOGGING_SDK_PROCESSOR
    [self.impObject shutdown];
#endif
}

- (void)forceFlush {
#ifdef OT_LOGGING_SDK_PROCESSOR
    [self.impObject forceFlush];
#endif
}

#pragma mark - Setter / Getter

- (void)setMaxQueueSize:(NSUInteger)maxQueueSize {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.maxQueueSize = maxQueueSize;
#endif
}

- (NSUInteger)maxQueueSize {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.maxQueueSize;
#endif
    return 0;
}

- (void)setProcessInterval:(NSTimeInterval)processInterval {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.processInterval = processInterval;
#endif
}

- (NSTimeInterval)processInterval {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.processInterval;
#endif
    return 0;
}

- (void)setMaxExportBatchSize:(NSUInteger)maxExportBatchSize {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.maxExportBatchSize = maxExportBatchSize;
#endif
}

- (NSUInteger)maxExportBatchSize {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.maxExportBatchSize;
#endif
    return 0;
}

- (void)setExporter:(id<OTLoggingExporterProtocol>)exporter {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.exporter = exporter;
#endif
}

- (id<OTLoggingExporterProtocol>)exporter {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.exporter;
#endif
    return nil;
}

- (OTResource *)resource {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.resource;
#endif
    return nil;
}

- (void)setResource:(OTResource *)resource {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.resource = resource;
#endif
}

- (OTExporterCallback)onLogReportedCallback {
#ifdef OT_LOGGING_SDK_PROCESSOR
    return self.impObject.onLogReportedCallback;
#else
    return nil;
#endif
}

- (void)setOnLogReportedCallback:(OTExporterCallback)onLogReportedCallback {
#ifdef OT_LOGGING_SDK_PROCESSOR
    self.impObject.onLogReportedCallback = onLogReportedCallback;
#endif
}

@end
