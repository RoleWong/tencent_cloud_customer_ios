//
//  OTLoggingProcessorImp.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingProcessorImp.h"
#import "OTLoggingRecord.h"
#import "OTSafeArray.h"
#import "OTLoggingExporter.h"

static char *const kGcdQueueName = "openTelemetry.queue.loggingProcessor";

@interface OTLoggingProcessorImp ()

@property (nonatomic, assign) BOOL isShutDown;
@property (nonatomic, strong) dispatch_source_t gcdTimer; // 计时器
@property (nonatomic, strong) dispatch_queue_t loggingProcessQueue;
@property (nonatomic, strong) OTSafeArray<OTLoggingRecordData *> *logsDataArray;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation OTLoggingProcessorImp

@synthesize processInterval = _processInterval;
@synthesize maxExportBatchSize = _maxExportBatchSize;
@synthesize maxQueueSize = _maxQueueSize;
@synthesize resource = _resource;
@synthesize exporter = _exporter;
@synthesize onLogReportedCallback = _onLogReportedCallback;

- (instancetype)init {
    if (self = [super init]) {
        _loggingProcessQueue = dispatch_queue_create(kGcdQueueName, DISPATCH_QUEUE_SERIAL);            // 初始化Log处理串行队列
        _logsDataArray = [[OTSafeArray alloc] init];                                                   // 初始化Log队列
        // 初始化处理器基本参数
        self.exporter = [[OTLoggingExporter alloc] init];
        self.maxQueueSize = 2048;
        self.processInterval = 5000;
        self.maxExportBatchSize = 512;
        // 初始化计时器
        [self timerInitialize];
    }
    return self;
}

- (void)addLogRecord:(OTLoggingRecord *)logRecord {
    if (self.logsDataArray.count <= self.maxQueueSize) {
        OTLoggingRecordData *logData = [[OTLoggingRecordData alloc] initWithLogingRecord:logRecord];
        [self.logsDataArray addObject:logData];
    }
}

#pragma mark - Getter & Setter

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSUInteger)maxQueueSize {
    NSUInteger maxSize = 0;
    [self.lock lock];
    maxSize = _maxQueueSize;
    [self.lock unlock];
    return maxSize;
}

- (void)setMaxQueueSize:(NSUInteger)maxQueueSize {
    [self.lock lock];
    _maxQueueSize = maxQueueSize;
    [self.lock unlock];
}

- (NSTimeInterval)processInterval {
    NSTimeInterval exportInterval = 0;
    [self.lock lock];
    exportInterval = _processInterval;
    [self.lock unlock];
    return exportInterval;
}

- (void)setProcessInterval:(NSTimeInterval)processInterval {
    [self.lock lock];
    if (processInterval > 0) {
        _processInterval = processInterval;
    }
    [self.lock unlock];
    [self timerInitialize];
}

- (NSUInteger)maxExportBatchSize {
    NSUInteger maxBatch = 0;
    [self.lock lock];
    maxBatch = _maxExportBatchSize;
    [self.lock unlock];
    return maxBatch;
}

- (void)setMaxExportBatchSize:(NSUInteger)maxExportBatchSize {
    [self.lock lock];
    _maxExportBatchSize = maxExportBatchSize;
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

- (id<OTLoggingExporterProtocol>)exporter {
    id<OTLoggingExporterProtocol> exporter = nil;
    [self.lock lock];
    exporter = _exporter;
    [self.lock unlock];
    return exporter;
}

- (void)setExporter:(id<OTLoggingExporterProtocol>)exporter {
    [self.lock lock];
    _exporter = exporter;
    [self.lock unlock];
}

- (OTExporterCallback)onLogReportedCallback {
    OTExporterCallback reportCallback = nil;
    [self.lock lock];
    reportCallback = _onLogReportedCallback;
    [self.lock unlock];
    return reportCallback;
}

- (void)setOnLogReportedCallback:(OTExporterCallback)onLogReportedCallback {
    [self.lock lock];
    _onLogReportedCallback = [onLogReportedCallback copy];
    [self.lock unlock];
}

#pragma mark - Private

- (void)timerInitialize {
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _loggingProcessQueue);
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, self.processInterval * NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        [self exportLogsFromSequence:self.logsDataArray];
    });
    dispatch_resume(_gcdTimer);
}

- (void)exportLogsFromSequence:(OTSafeArray<OTLoggingRecordData *> *)sequence {
    if (sequence.count == 0) {
        return;
    }
    
    NSArray *exportedArray = nil;
    if (sequence.count <= self.maxExportBatchSize) {
        exportedArray = [sequence fetchArray];
    } else {
        exportedArray = [[sequence fetchArray] subarrayWithRange:NSMakeRange(0, self.maxExportBatchSize)];
    }
    __weak typeof(self) weakSelf = self;
    [self exportBatchingLogRecordsData:exportedArray completion:^(NSInteger statusCode, NSString * _Nullable dataString, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.onLogReportedCallback) {
            strongSelf.onLogReportedCallback(statusCode, dataString, error);
        }
    }];
    [sequence removeObjectsInArray:exportedArray];
}

- (void)exportBatchingLogRecordsData:(NSArray<OTLoggingRecordData *> *)logRecordsData completion:(OTExporterCallback)completion {
    if (logRecordsData.count == 0 && completion) {
        completion(0, nil, nil);
        return;
    }
    OTResource *resource = self.resource;
    [self.exporter exportRecords:logRecordsData resource:resource completion:completion];
}

#pragma mark - SpanProcessor

- (void)shutdown {
    if (self.isShutDown) {
        return;
    }
    self.isShutDown = YES;
    // 清理准备上报的SpanData
    dispatch_async(_loggingProcessQueue, ^{
        [self.logsDataArray removeAllObjects];
    });
    // 被ShutDown之后停止计时器
    dispatch_source_cancel(_gcdTimer);
    [_exporter shutdown];
    // 可以在Span结束的时候为Span插入特征键值对, 此方法用于被子类重载
}

- (void)forceFlush {
    if (self.isShutDown) {
        return;
    }
    // 被Flush的处理器会强行导出所有已经结束的Span数据
    __weak typeof(self) weakSelf = self;
    dispatch_async(_loggingProcessQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf exportLogsFromSequence:strongSelf.logsDataArray];
    });
}

@end
