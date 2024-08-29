//
//  OTSpanProcessorImp.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanProcessorImp.h"

#import "OTSpanExporter.h"
#import "OTSafeArray.h"
#import "OTResource.h"
#import "OTSpan.h"
#import "OTSpanContext.h"
#import "OTTraceFlags.h"

static char *const kGcdTimerName = "openTelemetry.queue.spanProcessor";

@interface OTSpanProcessorImp () {
    BOOL _isShuttedDown;
    dispatch_source_t _gcdTimer;         // timer
    dispatch_queue_t _spansProcessQueue; // handleSpanQueue
}

/// Span data arrary with json form
@property (nonatomic, strong) OTSafeArray<OTSpanData *> *spansDataArray;

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation OTSpanProcessorImp

@synthesize processInterval = _processInterval;
@synthesize maxExportBatchSize = _maxExportBatchSize;
@synthesize maxQueueSize = _maxQueueSize;
@synthesize resource = _resource;
@synthesize onSpanStartedCallback = _onSpanStartedCallback;
@synthesize onSpanEndedCallback = _onSpanEndedCallback;
@synthesize onSpanReportedCallback = _onSpanReportedCallback;
@synthesize exporter = _exporter;

- (void)dealloc {
    dispatch_source_cancel(_gcdTimer);
}

- (instancetype)init {
    if (self = [super init]) {
        _spansProcessQueue = dispatch_queue_create(kGcdTimerName, DISPATCH_QUEUE_SERIAL); // 初始化Span处理串行队列
        _spansDataArray = [[OTSafeArray alloc] init];
        // 初始化处理器基本参数
        self.exporter = [[OTSpanExporter alloc] init];
        self.maxQueueSize = 2048;
        self.processInterval = 5000;
        self.maxExportBatchSize = 256;
        // 初始化计时器
        [self timerInitialize];
    }
    return self;
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

- (OTSpanStartedBlock)onSpanStartedCallback {
    OTSpanStartedBlock block = nil;
    [self.lock lock];
    block = _onSpanStartedCallback;
    [self.lock unlock];
    return block;
}

- (void)setOnSpanStartedCallback:(OTSpanStartedBlock)onSpanStartedCallback {
    [self.lock lock];
    _onSpanStartedCallback = [onSpanStartedCallback copy];
    [self.lock unlock];
}

- (OTSpanEndedBlock)onSpanEndedCallback {
    OTSpanEndedBlock block = nil;
    [self.lock lock];
    block = _onSpanEndedCallback;
    [self.lock unlock];
    return block;
}

- (void)setOnSpanEndedCallback:(OTSpanEndedBlock)onSpanEndedCallback {
    [self.lock lock];
    _onSpanEndedCallback = [onSpanEndedCallback copy];
    [self.lock unlock];
}

- (OTExporterCallback)onSpanReportedCallback {
    OTExporterCallback block = nil;
    [self.lock lock];
    block = _onSpanReportedCallback;
    [self.lock unlock];
    return block;
}

- (void)setOnSpanReportedCallback:(OTExporterCallback)onSpanReportedCallback {
    [self.lock lock];
    _onSpanReportedCallback = [onSpanReportedCallback copy];
    [self.lock unlock];
}

- (id<OTSpanExporterProtocol>)exporter {
    id<OTSpanExporterProtocol> exporter = nil;
    [self.lock lock];
    exporter = _exporter;
    [self.lock unlock];
    return exporter;
}

- (void)setExporter:(id<OTSpanExporterProtocol>)exporter {
    [self.lock lock];
    _exporter = exporter;
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

#pragma mark - Private

- (void)addSpanInSpansQueue:(OTSpan *)span {
    if (self.spansDataArray.count <= self.maxQueueSize) {
        OTSpanData *spanData = [[OTSpanData alloc] initWithSpan:span];
        [self.spansDataArray addObject:spanData];
    }
}

- (void)timerInitialize {
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _spansProcessQueue);
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, self.processInterval * NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        [self exportSpansFromSequence:self.spansDataArray];
    });
    dispatch_resume(_gcdTimer);
}

- (void)exportSpansFromSequence:(OTSafeArray<OTSpanData *> *)sequence {
    // when export stated, move sending spans from span array to spanSending array
    if (sequence.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSArray *exportedArray = nil;
    if (sequence.count <= self.maxExportBatchSize) {
        exportedArray = [[sequence fetchArray] subarrayWithRange:NSMakeRange(0, sequence.count)];
    } else {
        exportedArray = [[sequence fetchArray] subarrayWithRange:NSMakeRange(0, self.maxExportBatchSize)];
    }
    [self exportBatchingSpansData:exportedArray
                       completion:^(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error) {
                           __strong typeof(weakSelf) strongSelf = weakSelf;
                           if (strongSelf.onSpanReportedCallback) {
                               strongSelf.onSpanReportedCallback(statusCode, dataString, error);
                           }
                       }];
    [sequence removeObjectsInArray:exportedArray];
}

- (void)exportBatchingSpansData:(NSArray<OTSpanData *> *)spansData completion:(OTExporterCallback)completion {
    if (spansData.count == 0 && completion) {
        completion(0, nil, nil);
        return;
    }
    OTResource *resource = self.resource;
    [self.exporter exportSpansData:spansData resource:resource completion:completion];
}

#pragma mark - SpanProcessor

- (void)onStart:(nonnull OTSpan *)span {
    if (_isShuttedDown) {
        return;
    }
    if (self.onSpanStartedCallback) {
        self.onSpanStartedCallback(span);
    }
}

- (void)onEnd:(OTSpan *)span {
    if (_isShuttedDown) {
        return;
    }
    if (!span.context.traceFlags.isSampled) {
        return;
    }
    if (self.onSpanEndedCallback) {
        self.onSpanEndedCallback(span);
    }
    dispatch_async(_spansProcessQueue, ^{
        [self addSpanInSpansQueue:span];
    });
}

- (void)shutdown {
    if (_isShuttedDown) {
        return;
    }
    _isShuttedDown = YES;
    // 清理准备上报的SpanData
    dispatch_async(_spansProcessQueue, ^{
        [self.spansDataArray removeAllObjects];
    });
    // 被ShutDown之后停止计时器
    dispatch_source_cancel(_gcdTimer);
    [_exporter shutdown];
    // 可以在Span结束的时候为Span插入特征键值对, 此方法用于被子类重载
}

- (void)forceFlush {
    if (_isShuttedDown) {
        return;
    }
    // 被Flush的处理器会强行导出所有已经结束的Span数据
    dispatch_async(_spansProcessQueue, ^{
        [self exportSpansFromSequence:self.spansDataArray];
    });
}

@end
