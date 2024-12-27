//
//  OTAggregatorFactory.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregatorFactory.h"

#import "OTSumAggregator.h"
#import "OTHistogramAggregator.h"
#import "OTLastValueAggregator.h"
#import "NSNumber+OTJsonTools.h"
#import "OTHistogram.h"
#import "OTClockProtocol.h"
#import "OTMetricView.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_SPAN
#import "OTTracerProviderProtocol.h"
#endif

@interface OTaggregatorFactory ()

@end

@implementation OTaggregatorFactory

#pragma mark - Getter & Setter

+ (OTAggregatorType)aggregatorTypeWithInsrumentType:(OTInstrumentType)instrumentType {
    OTAggregatorType aggregatorType = OTAggregatorTypeNone;
    switch (instrumentType) {
        case OTInstrumentTypeCounter:
        case OTInstrumentTypeUpDownCounter:
        case OTInstrumentTypeObservableCounter:
        case OTInstrumentTypeObservalbleUpDownCounter:
            aggregatorType = OTAggregatorTypeSum;
            break;
        case OTInstrumentTypeHistogram:
            aggregatorType = OTAggregatorTypeHistogram;
            break;
        case OTInstrumentTypeObservableGauge:
            aggregatorType = OTAggregatorTypeLastValue;
            break;
        default:
            break;
    }
    return aggregatorType;
}

+ (OTAggregatorMonotonic)monotonicForInstrumentType:(OTInstrumentType)instrumentType {
    BOOL isNonmonotonic = instrumentType == OTInstrumentTypeUpDownCounter || instrumentType == OTInstrumentTypeUpDownCounter;
    OTAggregatorMonotonic type = isNonmonotonic ? OTAggregatorMonotonicNonmonitonic : OTAggregatorMonotonicMonitonic;
    return type;
}

+ (id<OTAggregatorProtocol>)createSumAggregatorWithTemporality:(OTAggregatorTemporality)temporality {
    OTSumAggregator *aggregator = [[OTSumAggregator alloc] init];
    aggregator.temporality = temporality;
    return aggregator;
}

+ (id<OTAggregatorProtocol>)createLastValueAggregatorWithTemporality:(OTAggregatorTemporality)temporality {
    OTLastValueAggregator *aggregator = [[OTLastValueAggregator alloc] init];
    aggregator.temporality = temporality;
    return aggregator;
}

+ (id<OTAggregatorProtocol>)createHistogramAggregatorWithTemporality:(OTAggregatorTemporality)temporality buckets:(OTSafeArray<NSNumber *> *)buckets {
    OTHistogramAggregator *aggregator = [[OTHistogramAggregator alloc] initWithExplicitBounds:buckets];
    aggregator.temporality = temporality;
    return aggregator;
}

+ (id<OTAggregatorProtocol>)createDefaultAggregatorForInstrument:(OTInstrument *)instrument {
    OTAggregatorType aggregatorType = [self aggregatorTypeWithInsrumentType:instrument.type];
    id<OTAggregatorProtocol> aggregator = nil;
    if (aggregatorType == OTAggregatorTypeSum) {
        aggregator = [self createSumAggregatorWithTemporality:OTAggregatorTemporalityDelta];
        aggregator.monotonic = [self monotonicForInstrumentType:instrument.type];
    } else if (aggregatorType == OTAggregatorTypeHistogram) {
        OTHistogram *histogram = (OTHistogram *)instrument;
        aggregator = [self createHistogramAggregatorWithTemporality:OTAggregatorTemporalityDelta buckets:histogram.buckets];
    } else if (aggregatorType == OTAggregatorTypeLastValue) {
        aggregator = [self createLastValueAggregatorWithTemporality:OTAggregatorTemporalityDelta];
    }
    aggregator.valueType = instrument.valueType;
    aggregator.name = instrument.name;
    aggregator.descriptionInfo = instrument.descriptionInfo;
    aggregator.unit = instrument.unit;
    return aggregator;
}

@end
