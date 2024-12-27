//
//  OTMetricReaderImp.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricReaderImp.h"

#import "OTMetricDataPoint.h"
#import "OTMetricDataSink.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTMeter.h"
#import "OTMetricExporter.h"
#import "OTSafeDictionary.h"

static char *const gOTMetricReaderQueueName = "openTelemetry.metric.reader.queue";

@interface OTMetricReaderImp () {
    dispatch_queue_t _metricReaderHandleQueue;
    dispatch_source_t _gcdTimer;
}

@property (nonatomic, assign) BOOL isShuttedDown;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation OTMetricReaderImp

@synthesize resource = _resource;
@synthesize onMetricReportedCallback = _onMetricReportedCallback;
@synthesize collectCallback = _collectCallback;
@synthesize onMetricDataRead = _onMetricDataRead;
@synthesize exporter = _exporter;
@synthesize readIntervalMillis = _readIntervalMillis;

- (instancetype)init {
    if (self = [super init]) {
        _metricReaderHandleQueue = dispatch_queue_create(gOTMetricReaderQueueName, DISPATCH_QUEUE_SERIAL);
        self.readIntervalMillis = 3000; // defualt read interval is 3000 millis
        self.exporter = [[OTMetricExporter alloc] init];
    }
    return self;
}

- (void)dealloc {
    dispatch_source_cancel(_gcdTimer);
}

#pragma mark - Getter & Setter

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSTimeInterval)readIntervalMillis {
    NSTimeInterval readIntervalMillis = 0;
    [self.lock lock];
    readIntervalMillis = _readIntervalMillis;
    [self.lock unlock];
    return readIntervalMillis;
}

- (void)setReadIntervalMillis:(NSTimeInterval)readIntervalMillis {
    [self.lock lock];
    if (readIntervalMillis > 0) {
        _readIntervalMillis = readIntervalMillis;
    }
    [self.lock unlock];
    [self timerInitialize];
}

- (id<OTMetricExporterProtocol>)exporter {
    id<OTMetricExporterProtocol> exporter = nil;
    [self.lock lock];
    exporter = _exporter;
    [self.lock unlock];
    return exporter;
}

- (void)setExporter:(id<OTMetricExporterProtocol>)exporter {
    [self.lock lock];
    _exporter = exporter;
    __weak typeof(self) weakSelf = self;
    exporter.needCollectMetricCallback = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf collect];
    };
    [self.lock unlock];
}

- (OTExporterCallback)onMetricReportedCallback {
    OTExporterCallback onMetricReportedCallback;
    [self.lock lock];
    onMetricReportedCallback = _onMetricReportedCallback;
    [self.lock unlock];
    return onMetricReportedCallback;
}

- (void)setOnMetricReportedCallback:(OTExporterCallback)onMetricReportedCallback {
    [self.lock lock];
    _onMetricReportedCallback = [onMetricReportedCallback copy];
    [self.lock unlock];
}

- (OTMetricReaderBlock)onMetricDataRead {
    OTMetricReaderBlock onMetricDataRead = nil;
    [self.lock lock];
    onMetricDataRead = _onMetricDataRead;
    [self.lock unlock];
    return onMetricDataRead;
}

- (void)setOnMetricDataRead:(OTMetricReaderBlock)onMetricDataRead {
    [self.lock lock];
    _onMetricDataRead = onMetricDataRead;
    [self.lock unlock];
}

- (OTResource *)resource {
    OTResource *resource = nil;
    [self.lock lock];
    resource = _resource;
    [self.lock unlock];
    return resource;
}

- (void)setResource:(OTResource *)resource {
    [self.lock lock];
    _resource = resource;
    [self.lock unlock];
}

- (OTMeterColletBlock)collectCallback {
    OTMeterColletBlock block = nil;
    [self.lock lock];
    block = _collectCallback;
    [self.lock unlock];
    return block;
}

- (void)setCollectCallback:(OTMeterColletBlock)collectCallback {
    [self.lock lock];
    _collectCallback = collectCallback;
    [self.lock unlock];
}

#pragma mark - Private

- (void)timerInitialize {
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
    // time responsible for read metric data in a period of time, interval is configured by readIntervalMillis property
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _metricReaderHandleQueue);
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, self.readIntervalMillis * NSEC_PER_MSEC, 0);
    __weak typeof(self) weakSelf = self;

    dispatch_source_set_event_handler(_gcdTimer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf read];
    });
    dispatch_resume(_gcdTimer);
}

#pragma mark - Public

/// Called by exporter, when exporter needs to report metric data to backend, this method will be called.
- (BOOL)collect {
    if (self.isShuttedDown) {
        return NO;
    }
    if (!self.collectCallback) {
        return NO;
    }

    OTSafeArray *safeMetricDatas = self.collectCallback();

    if (safeMetricDatas.count == 0) {
        return NO;
    }

    OTResource *resource = self.resource;
    __weak typeof(self) weakSelf = self;
    [self.exporter exportBatching:safeMetricDatas
                         resource:resource
                       completion:^(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error) {
                           __strong typeof(weakSelf) strongSelf = weakSelf;
                           if (strongSelf.onMetricReportedCallback) {
                               strongSelf.onMetricReportedCallback(statusCode, dataString, error);
                           }
                       }];
    return YES;
}

- (void)read {
    if (self.isShuttedDown) {
        return;
    }
    if (!self.onMetricDataRead) {
        return;
    }
    self.onMetricDataRead();
}

- (void)shutdown {
    if (self.isShuttedDown) {
        return;
    }
    self.isShuttedDown = YES;
    dispatch_source_cancel(_gcdTimer);
    [self.exporter shutdown];
}

- (void)forceFlush {
    [self.exporter forceFlush];
}

@end
