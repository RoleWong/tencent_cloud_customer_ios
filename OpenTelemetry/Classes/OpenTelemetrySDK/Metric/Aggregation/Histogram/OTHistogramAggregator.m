//
//  OTHistogramAggregator.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTHistogramAggregator.h"

#import "OTHistogramDataPoint.h"
#import "OTHistogramAggregation.h"
#import "OTMeasurement.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTMetricData.h"
#import "OTBucket.h"
#import "OTAggregator+Private.h"

@interface OTHistogramAggregator ()

@property (nonatomic, strong) OTSafeArray<OTBucket *> *bucketModels;
@property (nonatomic, strong) OTSafeArray<NSNumber *> *userDefinedExplicitBounds;

@end

@implementation OTHistogramAggregator

- (instancetype)initWithExplicitBounds:(OTSafeArray<NSNumber *> *)bounds {
    if (self = [super init]) {
        self.type = OTAggregatorTypeSum;
        _bucketModels = [[OTSafeArray alloc] init];
        self.userDefinedExplicitBounds = bounds;
    }
    return self;
}

#pragma mark - Getter & Setter

- (void)setMonotonic:(OTAggregatorMonotonic)monotonic {
    // histogram doese not allow nonmonitonic
    return;
}

- (void)setUserDefinedExplicitBounds:(OTSafeArray<NSNumber *> *)userDefinedExplicitBounds {
    if (![OTBucket qualifiedForBucketBoundaries:userDefinedExplicitBounds]) {
        return;
    }
    OTSafeArray *buckets = [OTBucket bucketsWithValueType:self.valueType explictBounds:userDefinedExplicitBounds];
    OTSafeArray *stashBackArray = [[OTSafeArray alloc] init];
    [stashBackArray addObjectsFromArray:[buckets fetchArray]];
    self.bucketModels = stashBackArray;
    _userDefinedExplicitBounds = userDefinedExplicitBounds;
}

#pragma mark - Public

- (OTMetricData *)toMetricData {

    OTMetricData *metricData = [[OTMetricData alloc] init];
    metricData.name = self.name;
    metricData.unit = self.unit;
    metricData.descriptionInfo = self.descriptionInfo;

    OTHistogramAggregation *aggregation = [[OTHistogramAggregation alloc] init];
    aggregation.temporality = self.temporality;
    aggregation.metricDataPoints = [self copyChartedDataPoints:self.chartedDataPoints];
    metricData.aggregation = aggregation;

    return metricData;
}

- (BOOL)canProcessMeasurement:(OTMeasurement *)measurement {
    BOOL canProcess = YES;
    if (self.valueType != measurement.valueType) {
        canProcess = NO;
    }
    if (self.bucketModels.count == 0) {
        canProcess = NO;
    }
    if (measurement.value.doubleValue < 0 && self.monotonic == OTAggregatorMonotonicMonitonic) {
        canProcess = NO;
    }
    return canProcess;
}

- (OTMetricDataPoint *)aggregateMeasurement:(OTMeasurement *)measurement {
    if (![self canProcessMeasurement:measurement]) {
        return nil;
    }
    [self.lock lock];
    OTHistogramDataPoint *dataPoint = (OTHistogramDataPoint *)[self.aggregatingDataPoints objectForKey:measurement.attributesKeyValuePairs];
    if (!dataPoint) {
        dataPoint = [[OTHistogramDataPoint alloc] init];
        [self dataPointInitialize:dataPoint];
        dataPoint.explicitBounds = [self.userDefinedExplicitBounds fetchArray];
        [self.aggregatingDataPoints setValue:dataPoint forKey:measurement.attributesKeyValuePairs];
    }
    if (measurement.valueType == OTNumericValueTypeLong) {
        NSInteger currentSum = dataPoint.sum.integerValue;
        NSInteger sumResult = currentSum + measurement.value.integerValue;
        dataPoint.sum = [NSNumber numberWithLong:sumResult];
    } else if (measurement.valueType == OTNumericValueTypeDouble) {
        NSTimeInterval currentSum = dataPoint.sum.doubleValue;
        NSTimeInterval sumResult = currentSum + measurement.value.doubleValue;
        dataPoint.sum = [NSNumber numberWithDouble:sumResult];
    }
    NSMutableArray *bucketCounts = [[NSMutableArray alloc] init];
    [self.bucketModels enumerateObjectsUsingBlock:^(OTBucket *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj shouldCaptureValue:measurement.value]) {
            dataPoint.count += 1;
        }
        // record every bucket's value count
        [bucketCounts addObject:@(obj.countValue)];
    }];
    dataPoint.bucketCounts = bucketCounts;
    [self.lock unlock];
    return dataPoint;
}

- (void)recordDataPointAndCollectExemplars {
    [super recordDataPointAndCollectExemplars];
    if (self.temporality != OTAggregatorTemporalityDelta) {
        return;
    }
    // if using delta temporality, reset start time and dataPoints after each collect
    self.startTime = self.clock.nanoSecondTime;
    [self.aggregatingDataPoints enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTMetricDataPoint *_Nonnull obj, BOOL *_Nonnull stop) {
        [self.lock lock];
        OTHistogramDataPoint *dataPoint = (OTHistogramDataPoint *)obj;
        dataPoint.count = 0;
        dataPoint.bucketCounts = @[];
        dataPoint.sum = @0;
        [self.lock unlock];
    }];
    [self.bucketModels enumerateObjectsUsingBlock:^(OTBucket *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.countValue = 0;
    }];
}

@end
