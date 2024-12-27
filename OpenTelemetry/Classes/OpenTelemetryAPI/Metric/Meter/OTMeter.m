//
//  OTMeter.m
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMeter.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTSafeDictionary.h"
#import "OTCounter.h"
#import "OTUpDownCounter.h"
#import "OTMetricData.h"
#import "OTObservableCounter.h"
#import "OTObservableUpDownCounter.h"
#import "OTObservableGauge.h"
#import "OTHistogram.h"
#import "OTMeter+OTMetricViewProcess.h"
#import "OTDependencyDefine.h"
#import "OTHistogram+Private.h"
#import "OTInstrument+Private.h"
#import "OTMetricData.h"
#ifdef OT_METRIC_SDK_INSTRUMENT
#import "OTInstrumentBuilder.h"
#import "OTAggregatorFactory.h"
#endif

@interface OTMeter () <OTInstrumentDelegate>

@property (nonatomic, strong, readwrite) OTInstrumentationLibraryInfo *libraryInfo;
@property (nonatomic, strong) OTSafeDictionary<NSString *, OTInstrument *> *instrumentCache;
@property (nonatomic, strong) OTSafeDictionary<NSString *, id<OTAggregatorProtocol>> *aggregatorCache;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation OTMeter

- (instancetype)initWithLibraryInfo:(OTInstrumentationLibraryInfo *)info {
    if (self = [super init]) {
        _libraryInfo = info;
        _lock = [[NSRecursiveLock alloc] init];
        _instrumentCache = [[OTSafeDictionary alloc] init];
        _aggregatorCache = [[OTSafeDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _lock = nil;
}

#pragma mark - Private

- (OTInstrument *)createInstrumentWithType:(OTInstrumentType)type
                                 valueType:(OTNumericValueType)valueType
                                      name:(NSString *)name
                                      unit:(NSString *)unit
                               description:(NSString *)description {
    OTInstrument *instrument = nil;
    NSString *cachedKey = [self createInstrumentCachedKeyFromName:name type:type];
#ifdef OT_METRIC_SDK_INSTRUMENT
    if ([self.instrumentCache objectForKey:cachedKey]) {
        instrument = [self.instrumentCache objectForKey:cachedKey];
        return instrument;
    }
    OTInstrumentBuilder *builder = [[OTInstrumentBuilder alloc] init];
    builder = [[[[[builder configType:type] configValueType:valueType] configName:name] configUnit:unit] configDescription:description];
    OTInstrument *readableInstrument = [builder build];
    if (readableInstrument) {
        instrument = readableInstrument;
        [self.instrumentCache setObject:instrument forKey:cachedKey];
        instrument.delegate = self;
    }
#endif
    return instrument;
}

- (NSString *)createInstrumentCachedKeyFromName:(NSString *)name type:(OTInstrumentType)type {
    return [NSString stringWithFormat:@"%zd_%@", type, name];
}

/// return last matched metric view for measurement
/// @param measurement measurement description
- (OTMetricView *)lastMatchedMetricViewForMeasurement:(OTMeasurement *)measurement {
    OTSafeArray<OTMetricView *> *metricViews = nil;
    if (self.acquireMetricViewsHandler) {
        metricViews = self.acquireMetricViewsHandler();
    }
    OTMetricView *matchedView = [self matchedViewFromMetricViews:metricViews measurement:measurement];
    return matchedView;
}

/// use aggregator from view or create default aggregator
/// @param metricView metricView description
/// @param instrument instrument description
- (id<OTAggregatorProtocol>)aggregatorFromMetricView:(OTMetricView *)metricView instrument:(OTInstrument *)instrument {
    id<OTAggregatorProtocol> aggregator = nil;
    aggregator = [metricView.params objectForKey:OTMetricViewKeyAggregator];
#ifdef OT_METRIC_SDK_INSTRUMENT
    if (!aggregator) {
        aggregator = [OTaggregatorFactory createDefaultAggregatorForInstrument:instrument];
    }
#endif
    return aggregator;
}

#pragma mark - Public

- (OTCounter *)createCounter:(NSString *)name unit:(NSString *)unit description:(NSString *)description {
    [self.lock lock];
    OTCounter *counter = (OTCounter *)[self createInstrumentWithType:OTInstrumentTypeCounter
                                                           valueType:OTNumericValueTypeLong
                                                                name:name
                                                                unit:unit
                                                         description:description];
    [self.lock unlock];
    return counter;
}

- (OTCounter *)createDoubleCounter:(NSString *)name unit:(NSString *)unit description:(NSString *)description {
    [self.lock lock];
    OTCounter *counter = (OTCounter *)[self createInstrumentWithType:OTInstrumentTypeCounter
                                                           valueType:OTNumericValueTypeDouble
                                                                name:name
                                                                unit:unit
                                                         description:description];
    [self.lock unlock];
    return counter;
}

- (OTUpDownCounter *)createUpdownCounter:(NSString *)name unit:(NSString *)unit description:(NSString *)description {
    [self.lock lock];
    OTUpDownCounter *upDownCounter = (OTUpDownCounter *)[self createInstrumentWithType:OTInstrumentTypeUpDownCounter
                                                                             valueType:OTNumericValueTypeLong
                                                                                  name:name
                                                                                  unit:unit
                                                                           description:description];
    [self.lock unlock];
    return upDownCounter;
}

- (OTUpDownCounter *)createUpdownDoubleCounter:(NSString *)name unit:(NSString *)unit description:(NSString *)description {
    [self.lock lock];
    OTUpDownCounter *upDownCounter = (OTUpDownCounter *)[self createInstrumentWithType:OTInstrumentTypeUpDownCounter
                                                                             valueType:OTNumericValueTypeDouble
                                                                                  name:name
                                                                                  unit:unit
                                                                           description:description];
    [self.lock unlock];
    return upDownCounter;
}

- (OTObservableCounter *)createObservableCounter:(NSString *)name
                                            unit:(NSString *)unit
                                     description:(NSString *)description
                                       onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableCounter *asyncCounter = (OTObservableCounter *)[self createInstrumentWithType:OTInstrumentTypeObservableCounter
                                                                                    valueType:OTNumericValueTypeLong
                                                                                         name:name
                                                                                         unit:unit
                                                                                  description:description];
    // only set callback when it's a newly create instrument
    if (!asyncCounter.observableCallback) {
        asyncCounter.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncCounter;
}

- (OTObservableCounter *)createObservableDoubleCounter:(NSString *)name
                                                  unit:(NSString *)unit
                                           description:(NSString *)description
                                             onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableCounter *asyncCounter = (OTObservableCounter *)[self createInstrumentWithType:OTInstrumentTypeObservableCounter
                                                                                    valueType:OTNumericValueTypeDouble
                                                                                         name:name
                                                                                         unit:unit
                                                                                  description:description];
    // only set callback when it's a newly create instrument
    if (!asyncCounter.observableCallback) {
        asyncCounter.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncCounter;
}

- (OTObservableUpDownCounter *)createObservableUpDownCounter:(NSString *)name
                                                        unit:(NSString *)unit
                                                 description:(NSString *)description
                                                   onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableUpDownCounter *asyncCounter = (OTObservableUpDownCounter *)[self createInstrumentWithType:OTInstrumentTypeObservalbleUpDownCounter
                                                                                                valueType:OTNumericValueTypeLong
                                                                                                     name:name
                                                                                                     unit:unit
                                                                                              description:description];
    // only set callback when it's a newly create instrument
    if (!asyncCounter.observableCallback) {
        asyncCounter.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncCounter;
}

- (OTObservableUpDownCounter *)createObservableUpDownDoubleCounter:(NSString *)name
                                                              unit:(NSString *)unit
                                                       description:(NSString *)description
                                                         onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableUpDownCounter *asyncCounter = (OTObservableUpDownCounter *)[self createInstrumentWithType:OTInstrumentTypeObservalbleUpDownCounter
                                                                                                valueType:OTNumericValueTypeDouble
                                                                                                     name:name
                                                                                                     unit:unit
                                                                                              description:description];
    // only set callback when it's a newly create instrument
    if (!asyncCounter.observableCallback) {
        asyncCounter.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncCounter;
}

- (OTObservableGauge *)createObservableGauge:(NSString *)name
                                        unit:(NSString *)unit
                                 description:(NSString *)description
                                   onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableGauge *asyncGauge = (OTObservableGauge *)[self createInstrumentWithType:OTInstrumentTypeObservableGauge
                                                                              valueType:OTNumericValueTypeLong
                                                                                   name:name
                                                                                   unit:unit
                                                                            description:description];
    // only set callback when it's a newly create instrument
    if (!asyncGauge.observableCallback) {
        asyncGauge.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncGauge;
}

- (OTObservableGauge *)createObservableDoubleGauge:(NSString *)name
                                              unit:(NSString *)unit
                                       description:(NSString *)description
                                         onCollect:(OTObservableMeasurementBlock)onCollect {
    [self.lock lock];
    OTObservableGauge *asyncGauge = (OTObservableGauge *)[self createInstrumentWithType:OTInstrumentTypeObservableGauge
                                                                              valueType:OTNumericValueTypeDouble
                                                                                   name:name
                                                                                   unit:unit
                                                                            description:description];
    // only set callback when it's a newly create instrument
    if (!asyncGauge.observableCallback) {
        asyncGauge.observableCallback = onCollect;
    }
    [self.lock unlock];
    return asyncGauge;
}

- (OTHistogram *)createHistogram:(NSString *)name
                            unit:(NSString *)unit
                     description:(NSString *)description
                         buckets:(nonnull NSArray<NSNumber *> *)buckets {
    [self.lock lock];
    OTHistogram *histogram = (OTHistogram *)[self createInstrumentWithType:OTInstrumentTypeHistogram
                                                                 valueType:OTNumericValueTypeLong
                                                                      name:name
                                                                      unit:unit
                                                               description:description];
    // only set buckets when it's a newly create instrument
    if (!histogram.buckets) {
        NSMutableArray *bucketBounds = [[NSMutableArray alloc] initWithArray:buckets];
        histogram.buckets = [[OTSafeArray alloc] initWithNSMutableArray:bucketBounds];
    }
    // create aggregator if needed
    [self.lock unlock];
    return histogram;
}

- (OTHistogram *)createDoubleHistogram:(NSString *)name
                                  unit:(NSString *)unit
                           description:(NSString *)description
                               buckets:(nonnull NSArray<NSNumber *> *)buckets {
    [self.lock lock];
    OTHistogram *histogram = (OTHistogram *)[self createInstrumentWithType:OTInstrumentTypeHistogram
                                                                 valueType:OTNumericValueTypeDouble
                                                                      name:name
                                                                      unit:unit
                                                               description:description];
    NSMutableArray *bucketBounds = [[NSMutableArray alloc] initWithArray:buckets];
    histogram.buckets = [[OTSafeArray alloc] initWithNSMutableArray:bucketBounds];
    [self.lock unlock];
    return histogram;
}

- (OTInstrument *)registeredInstrumentWithName:(NSString *)name type:(OTInstrumentType)type {
    OTSafeDictionary *collection = self.instrumentCache;
    OTInstrument *instrument = [collection objectForKey:name];
    return instrument;
}

- (void)removeRegisteredInstrumentWithName:(NSString *)name type:(OTInstrumentType)type {
    OTSafeDictionary *collection = self.instrumentCache;
    [collection removeObjectForKey:name];
}

- (void)createNewDataPoint {
    [self.lock lock];
    [self.aggregatorCache
        enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTAggregatorProtocol> _Nonnull aggregator, BOOL *_Nonnull stop) {
            [aggregator recordDataPointAndCollectExemplars];
        }];
    [self.lock unlock];
}

- (void)triggerObservableInstruments {
    [self.instrumentCache enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTInstrument *_Nonnull obj, BOOL *_Nonnull stop) {
        [obj triggeredObservableCallback];
    }];
}

- (OTSafeArray<OTMetricData *> *)collectMetricDataFromAggregators {
    OTSafeArray *metricDatas = [[OTSafeArray alloc] init];
#ifdef OT_METRIC_SDK_INSTRUMENT
    [self.lock lock];
    [self.aggregatorCache
        enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTAggregatorProtocol> _Nonnull aggregator, BOOL *_Nonnull stop) {
            OTMetricData *metricData = [aggregator collectMetricData];
            if (metricData.aggregation.metricDataPoints.count > 0) {
                [metricDatas addObject:metricData];
            }
        }];
    [self.lock unlock];
#endif
    return metricDatas;
}

#pragma mark - OTInstrumentDelegate

- (void)instrument:(OTInstrument *)instrument triggeredWithMeasurement:(OTMeasurement *)measurement {
    [self.lock lock];
    // check all view if there is a suitable view;
    OTMetricView *matchedView = [self lastMatchedMetricViewForMeasurement:measurement];
    // reuse cached aggregator
    id<OTAggregatorProtocol> aggregator = [self.aggregatorCache objectForKey:measurement.name];
    // if no cached aggregator, try to use aggregator from metric view or create a default one.
    if (!aggregator) {
        aggregator = [self aggregatorFromMetricView:matchedView instrument:instrument];
        [self.aggregatorCache setValue:aggregator forKey:measurement.name];
    }
    // apply otherview configs
    [aggregator applyConfigurationsFromMetricViewParams:matchedView.params];
    // offer measurement to aggregator
    [aggregator offerMeasurement:measurement];
    [self.lock unlock];
}

@end
