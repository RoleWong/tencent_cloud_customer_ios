//
//  OTLastValueAggregator.m
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLastValueAggregator.h"

#import "OTNumberDataPoint.h"
#import "OTMeasurement.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTMetricData.h"
#import "OTLastValueAggregation.h"
#import "OTAggregator+Private.h"

@interface OTLastValueAggregator ()

@end

@implementation OTLastValueAggregator

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTAggregatorTypeLastValue;
    }
    return self;
}

#pragma mark - OTAggregatorProtocol

- (OTMetricData *)toMetricData {
    OTLastValueAggregation *aggregation = [[OTLastValueAggregation alloc] init];
    aggregation.metricDataPoints = [self copyChartedDataPoints:self.chartedDataPoints];

    OTMetricData *metricData = [[OTMetricData alloc] init];
    metricData.name = self.name;
    metricData.unit = self.unit;
    metricData.descriptionInfo = self.descriptionInfo;
    metricData.aggregation = aggregation;

    return metricData;
}

- (BOOL)canProcessMeasurement:(OTMeasurement *)measurement {
    BOOL canProcess = NO;
    if (measurement.valueType == self.valueType) {
        canProcess = YES;
    }
    return canProcess;
}

- (BOOL)needReportWithDataPoint:(OTMetricDataPoint *)dataPoint {
    // whatever the value is, the data point is necessary for gauge instruments, even zero is meaningful.
    return YES;
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

    if (measurement.valueType == OTNumericValueTypeLong) {
        dataPoint.value = [NSNumber numberWithLong:measurement.value.longValue];
    } else if (measurement.valueType == OTNumericValueTypeDouble) {
        dataPoint.value = [NSNumber numberWithDouble:measurement.value.doubleValue];
    }
    [self.lock unlock];
    return dataPoint;
}

- (void)recordDataPointAndCollectExemplars {
    [super recordDataPointAndCollectExemplars];
    // if using delta temporality, reset start time after each collect
    if (self.temporality == OTAggregatorTemporalityDelta) {
        self.startTime = self.clock.nanoSecondTime;
    }
}

@end
