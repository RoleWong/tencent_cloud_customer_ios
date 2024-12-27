//
//  OTMetricExporterImp.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricExporterImp.h"
#import "OTDependencyDefine.h"
#import "OTSafeArray.h"
#import "OTReportEngine.h"
#import "OTMetricDataSink.h"
#import "OTMetricDataReportKeys.h"
#import "OTResource.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTMetricJsonConverter.h"

static char *const gOTMetricExporterQueueName = "openTelemetry.metric.exporter.queue";

@interface OTMetricExporterImp () {
    dispatch_queue_t _metricExporterHandleQueue;
    dispatch_source_t _gcdTimer;
}

@property (nonatomic, strong) OTResource *resource;
@property (nonatomic, assign) BOOL isShuttedDown;

@end

@implementation OTMetricExporterImp

- (instancetype)init {
    if (self = [super init]) {
        _metricExporterHandleQueue = dispatch_queue_create(gOTMetricExporterQueueName, DISPATCH_QUEUE_SERIAL);
        self.exportTimeIntervalMills = 15000;
    }
    return self;
}

- (void)dealloc {
    dispatch_source_cancel(_gcdTimer);
}

#pragma mark - Getter & Setter

- (id<OTReportEngineProtocol>)delegate {
    if (!_delegate) {
        _delegate = [[OTReportEngine alloc] init];
    }
    return _delegate;
}

- (void)setExportTimeIntervalMills:(NSTimeInterval)exportTimeIntervalMills {
    if (exportTimeIntervalMills < 0) {
        return;
    }
    _exportTimeIntervalMills = exportTimeIntervalMills;
    [self timerInitialize];
}

#pragma mark - Private

- (void)timerInitialize {
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }

    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _metricExporterHandleQueue);
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, self.exportTimeIntervalMills * NSEC_PER_MSEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_gcdTimer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.mode == OTMetricExporterModePush) {
            [strongSelf exportMetricData];
        }
    });
    dispatch_resume(_gcdTimer);
}

#pragma mark - Public

- (void)exportBatching:(OTSafeArray<OTMetricDataSink *> *)batchedMetricData
              resource:(OTResource *)resource
            completion:(OTExporterCallback)completion {
    if (self.isShuttedDown) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(reportMetircData:extParam:completion:)]) {
        NSError *notImplementError =
            [NSError errorWithDomain:gOTExporterErrorDomain
                                code:gOTExporterNotReportEngine
                            userInfo:@{ NSLocalizedDescriptionKey : @"Report engine is not implemented metric json data export" }];
        completion(0, nil, notImplementError);
        return;
    }
    NSDictionary *parameters = [OTMetricJsonConverter metricParametersToExport:batchedMetricData resource:resource];
    NSError *jsonError = nil;
    OTCarrier *jsonCarrier = [OTCarrier carrierWithJsonObject:parameters error:&jsonError];
    if (jsonError) {
        completion(0, nil, jsonError);
    } else {
        [self.delegate reportMetircData:jsonCarrier extParam:self.headerForRequest completion:completion];
    }
}

- (void)forceFlush {
    if (self.mode == OTMetricExporterModePull) {
        return;
    }
    [self exportMetricData];
}

- (void)shutdown {
    if (self.isShuttedDown) {
        return;
    }
    self.isShuttedDown = YES;
    dispatch_source_cancel(_gcdTimer);
}

- (void)exportMetricData {
    if (self.needCollectMetricCallback) {
        self.needCollectMetricCallback();
    }
}

@end
