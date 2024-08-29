//
//  OTMetricReader.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricReader.h"

#import "OTDependencyDefine.h"
#ifdef OT_METRIC_SDK_READER
#import "OTMetricReaderImp.h"
#endif

@interface OTMetricReader ()

#ifdef OT_METRIC_SDK_READER
@property (nonatomic, strong) OTMetricReaderImp *impObject;
#endif

@end

@implementation OTMetricReader

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_METRIC_SDK_READER
        _impObject = [[OTMetricReaderImp alloc] init];
#endif
    }
    return self;
}

#pragma mark - Getter & Setter

- (OTResource *)resource {
#ifdef OT_METRIC_SDK_READER
    return self.impObject.resource;
#else
    return nil;
#endif
}

- (void)setResource:(OTResource *)resource {
#ifdef OT_METRIC_SDK_READER
    self.impObject.resource = resource;
#endif
}

- (id<OTMetricExporterProtocol>)exporter {
#ifdef OT_METRIC_SDK_READER
    return [self.impObject exporter];
#else
    return nil;
#endif
}

- (void)setExporter:(id<OTMetricExporterProtocol>)exporter {
#ifdef OT_METRIC_SDK_READER
    [self.impObject setExporter:exporter];
#endif
}

- (OTMeterColletBlock)collectCallback {
#ifdef OT_METRIC_SDK_READER
    return [self.impObject collectCallback];
#else
    return nil;
#endif
}

- (void)setCollectCallback:(OTMeterColletBlock)collectCallback {
#ifdef OT_METRIC_SDK_READER
    [self.impObject setCollectCallback:collectCallback];
#endif
}

- (OTMetricReaderBlock)onMetricDataRead {
#ifdef OT_METRIC_SDK_READER
    return self.impObject.onMetricDataRead;
#else
    return nil;
#endif
}

- (void)setOnMetricDataRead:(OTMetricReaderBlock)onMetricDataRead {
#ifdef OT_METRIC_SDK_READER
    self.impObject.onMetricDataRead = onMetricDataRead;
#endif
}

- (void)setReadIntervalMillis:(NSTimeInterval)readIntervalMillis {
#ifdef OT_METRIC_SDK_READER
    [self.impObject setReadIntervalMillis:readIntervalMillis];
#endif
}

- (NSTimeInterval)readIntervalMillis {
#ifdef OT_METRIC_SDK_READER
    return [self.impObject readIntervalMillis];
#else
    return 0;
#endif
}

- (void)forceFlush {
#ifdef OT_METRIC_SDK_READER
    [self.impObject forceFlush];
#endif
}

- (void)shutdown {
#ifdef OT_METRIC_SDK_READER
    [self.impObject shutdown];
#endif
}

- (OTExporterCallback)onMetricReportedCallback {
#ifdef OT_METRIC_SDK_READER
    return self.impObject.onMetricReportedCallback;
#else
    return nil;
#endif
}

- (void)setOnMetricReportedCallback:(OTExporterCallback)onMetricReportedCallback {
#ifdef OT_METRIC_SDK_READER
    self.impObject.onMetricReportedCallback = onMetricReportedCallback;
#endif
}

@end
