//
//  OTAggregator.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTAggregator.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"
#import "OTAttributesWithCapacity.h"
#import "OTMetricDataPoint.h"
#import "OTClock.h"
#import "OTDependencyDefine.h"
#ifdef OT_METRIC_SDK_EXEMPLAR_FILTER
#import "OTExemplarFilter.h"
#endif

#ifdef OT_METRIC_SDK_EXEMPLAR_RESERVOIR
#import "OTExemplarReservoir.h"
#endif

@interface OTAggregator ()

@property (nonatomic, strong) OTSafeDictionary<NSString *, OTMetricDataPoint *> *aggregatingDataPoints;

@end

@implementation OTAggregator

- (void)dealloc {
    _lock = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _aggregatingDataPoints = [[OTSafeDictionary alloc] init];
        _chartedDataPoints = [[OTSafeArray alloc] init];
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

#pragma mark - Getter & Setter

- (id<OTClockProtocol>)clock {
    if (!_clock) {
        _clock = [[OTClock alloc] init];
    }
    return _clock;
}

- (NSTimeInterval)startTime {
    if (_startTime == 0) {
        _startTime = [self.clock nanoSecondTime];
    }
    return _startTime;
}

#pragma mark - Public

- (void)dataPointInitialize:(OTMetricDataPoint *)dataPoint {
    dataPoint.startTimeUnixNano = self.startTime;
    dataPoint.timeUnixNano = [self.clock nanoSecondTime];
    dataPoint.name = self.name;
    dataPoint.descriptionInfo = self.descriptionInfo;
    dataPoint.unit = self.unit;
    dataPoint.valueType = self.valueType;
}

#pragma mark - OTAggregatorProtocol

- (OTMetricData *)collectMetricData {
    OTMetricData *metricData = [self toMetricData];
    // empty all charted data points when collected
    [self.chartedDataPoints removeAllObjects];
    return metricData;
}

- (OTMetricData *)toMetricData {
    NSAssert(NO, @"This is an abstract class, %s must be implemented by subclasses", __FUNCTION__);
    return nil;
}

- (void)offerMeasurement:(nonnull OTMeasurement *)measurement {
    OTSafeArray<OTAttribute *> *filteredAttributes = [self filteredAttributesByAggregatorAttrributeKeysForAttributes:measurement.attributes];
    // pass the measurement to subcalsses
    [self.lock lock];
    OTMetricDataPoint *aggregatingDataPoint = [self aggregateMeasurement:measurement];
    aggregatingDataPoint.attributes = filteredAttributes;
    [self configExemplarForDataPoint:aggregatingDataPoint measurement:measurement];
    [self.lock unlock];
}

- (OTMetricDataPoint *)aggregateMeasurement:(OTMeasurement *)measurement {
    NSAssert(NO, @"This is an abstract class, %s must be implemented by subclasses", __FUNCTION__);
    return nil;
}

- (BOOL)canProcessMeasurement:(OTMeasurement *)measurement {
    NSAssert(NO, @"This is an abstract class, %s must be implemented by subclasses", __FUNCTION__);
    return NO;
}

- (void)configExemplarForDataPoint:(OTMetricDataPoint *)dataPoint measurement:(OTMeasurement *)measurement {
    // collect exemplar
    OTExemplar *exemplar = [self.reservoir exemplarConvertedFromMeasurement:measurement];
    if (exemplar && dataPoint.exemplars.count < self.reservoir.filter.maxExemplarsForEachDataPoint) {
        [dataPoint.exemplars addObject:exemplar];
    }
}

- (OTSafeArray<OTAttribute *> *)filteredAttributesByAggregatorAttrributeKeysForAttributes:(OTSafeArray<OTAttribute *> *)attributes {
    if (self.attributeKyes.count == 0) {
        OTSafeArray *filteredAttribute = [[OTSafeArray alloc] initWithNSArray:attributes.fetchArray];
        return filteredAttribute;
    }
    OTSafeArray *filteredAttribute = [[OTSafeArray alloc] init];
    OTAttributesWithCapacity *tempAttributesCollection = [[OTAttributesWithCapacity alloc] initWithCapacity:attributes.count];
    [tempAttributesCollection updateAttributes:[attributes fetchArray]];
    [self.attributeKyes enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        OTAttribute *validAttribute = [tempAttributesCollection attributeForKey:obj];
        if (validAttribute) {
            [filteredAttribute addObject:validAttribute];
        }
    }];
    return filteredAttribute;
}

- (void)recordDataPointAndCollectExemplars {
    // Collect currrent data points and copy them represent thme as current aggregator status
    OTSafeArray *chartedDataPoints = [self copyAggregatingDataPoints:self.aggregatingDataPoints];
    // add these data points to already charted data points array
    [self.chartedDataPoints addObjectsFromArray:[chartedDataPoints fetchArray]];
    // remove aggregating data points
    [self.aggregatingDataPoints removeAllObjects];
}

- (OTSafeArray *)copyAggregatingDataPoints:(OTSafeDictionary<NSString *, OTMetricDataPoint *> *)aggregatingDataPoints {
    OTSafeArray *copiedDataPoint = [[OTSafeArray alloc] init];
    [aggregatingDataPoints enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTMetricDataPoint *_Nonnull obj, BOOL *_Nonnull stop) {
        OTMetricDataPoint *unarchivedDataPoint = [self safeCopyMetricDataPoint:obj];
        if (unarchivedDataPoint) {
            [copiedDataPoint addObject:unarchivedDataPoint];
        }
        // remove all exemplar after copy
        [obj.exemplars removeAllObjects];
    }];
    return copiedDataPoint;
}

- (OTSafeArray *)copyChartedDataPoints:(OTSafeArray<OTMetricDataPoint *> *)chartedDataPoints {
    OTSafeArray *copiedDataPoint = [[OTSafeArray alloc] init];
    [chartedDataPoints enumerateObjectsUsingBlock:^(OTMetricDataPoint *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([self needReportWithDataPoint:obj]) {
            OTMetricDataPoint *unarchivedDataPoint = [self safeCopyMetricDataPoint:obj];
            // Only copy valid datapoint in delta mode
            if (unarchivedDataPoint) {
                [copiedDataPoint addObject:unarchivedDataPoint];
            }
        }
    }];
    return copiedDataPoint;
}

- (BOOL)needReportWithDataPoint:(OTMetricDataPoint *)dataPoint {
    return self.temporality == OTAggregatorTemporalityDelta && [dataPoint isValidDataPoint];
}

- (OTMetricDataPoint *)safeCopyMetricDataPoint:(OTMetricDataPoint *)metricDataPoint {
    NSError *error = nil;
    OTMetricDataPoint *unarchivedDataPoint = nil;
    [self.lock lock];
    if (@available(iOS 11.0, *)) {
        NSData *dataPointData = [NSKeyedArchiver archivedDataWithRootObject:metricDataPoint requiringSecureCoding:YES error:&error];
        NSSet *classSet = [NSSet setWithObjects:NSNumber.class, NSString.class, OTSafeArray.class, NSArray.class, OTBaseObject.class, nil];
        unarchivedDataPoint = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:dataPointData error:&error];
    } else {
        // Fallback on earlier versions
        NSData *dataPointData = [NSKeyedArchiver archivedDataWithRootObject:metricDataPoint];
        unarchivedDataPoint = [NSKeyedUnarchiver unarchiveObjectWithData:dataPointData];
    }
    [self.lock unlock];
    return unarchivedDataPoint;
}

- (void)applyConfigurationsFromMetricViewParams:(OTSafeDictionary<OTMetricViewKey, id> *)params {
    id<OTExemplarReservoirProtocol> reservoir = [params objectForKey:OTMetricViewKeyExemplarReservoir];
    if (reservoir) {
        self.reservoir = reservoir;
    }
    OTSafeArray<NSString *> *attributeKeys = [params objectForKey:OTMetricViewKeyAttributeKeys];
    if (attributeKeys.count > 0) {
        self.attributeKyes = attributeKeys;
    }
    NSString *name = (NSString *)[params objectForKey:OTMetricViewKeyName];
    if (name.length > 0) {
        self.name = name;
    }
    NSString *descriptionInfo = [params objectForKey:OTMetricViewKeyDescription];
    if (descriptionInfo.length > 0) {
        self.descriptionInfo = descriptionInfo;
    }
}

@end
