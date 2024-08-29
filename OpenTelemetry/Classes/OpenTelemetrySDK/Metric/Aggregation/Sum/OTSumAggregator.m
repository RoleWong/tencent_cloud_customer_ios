//
//  OTSumAggregator.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSumAggregator.h"

#import "OTSumAggregation.h"
#import "OTNumberDataPoint.h"
#import "OTMeasurement.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTMetricData.h"
#import "OTAggregator+Private.h"

@interface OTSumAggregator ()

@end

@implementation OTSumAggregator

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTAggregatorTypeSum;
    }
    return self;
}

- (OTMetricData *)toMetricData {
    OTSumAggregation *aggregation = [[OTSumAggregation alloc] init];
    aggregation.metricDataPoints = [self copyChartedDataPoints:self.chartedDataPoints];
    aggregation.monotonic = self.monotonic;
    aggregation.temporality = self.temporality;

    OTMetricData *metricData = [[OTMetricData alloc] init];
    metricData.name = self.name;
    metricData.unit = self.unit;
    metricData.descriptionInfo = self.descriptionInfo;
    metricData.aggregation = aggregation;
    return metricData;
}

- (BOOL)canProcessMeasurement:(OTMeasurement *)measurement {
    BOOL canProcess = NO;
    // invalid value type
    if (self.valueType != measurement.valueType) {
        return canProcess;
    }
    // invalid monotonic
    if (self.monotonic == OTAggregatorMonotonicMonitonic) {
        if (measurement.value.doubleValue < 0) {
            return canProcess;
        }
    }
    canProcess = YES;
    return canProcess;
}

- (OTMetricDataPoint *)aggregateMeasurement:(OTMeasurement *)measurement {
    if (![self canProcessMeasurement:measurement]) {
        return nil;
    }
    [self.lock lock];
    OTNumberDataPoint *dataPoint = (OTNumberDataPoint *)[self.aggregatingDataPoints objectForKey:measurement.attributesKeyValuePairs];
    if (!dataPoint) {
        dataPoint = [[OTNumberDataPoint alloc] init];
        [self dataPointInitialize:dataPoint];
        [self.aggregatingDataPoints setValue:dataPoint forKey:measurement.attributesKeyValuePairs];
    }
    NSTimeInterval currentSum = dataPoint.doubleValue;
    NSTimeInterval sumResult = currentSum + measurement.value.doubleValue;
    dataPoint.value = [NSNumber numberWithDouble:sumResult];
    [self.lock unlock];
    return dataPoint;
}

- (void)recordDataPointAndCollectExemplars {
    [super recordDataPointAndCollectExemplars];
    if (self.temporality != OTAggregatorTemporalityDelta) {
        return;
    }
    // if using delta temporality, reset start time and datapoints value after each collect
    self.startTime = self.clock.nanoSecondTime;
    [self.aggregatingDataPoints enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTMetricDataPoint *_Nonnull obj, BOOL *_Nonnull stop) {
        [self.lock lock];
        OTNumberDataPoint *dataPoint = (OTNumberDataPoint *)obj;
        dataPoint.value = @0;
        [self.lock unlock];
    }];
}

@end
