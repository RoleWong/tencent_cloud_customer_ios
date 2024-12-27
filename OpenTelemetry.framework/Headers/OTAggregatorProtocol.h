//
//  OTAggregatorProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef OTAggregatorProtocol_h
#define OTAggregatorProtocol_h

#import "OTValueTypeDefine.h"
#import "OTClockProtocol.h"
#import "OTMeasurement.h"
#import "OTExemplarReservoirProtocol.h"
#import "OTMetricDataPoint.h"
#import "OTSafeArray.h"
#import "OTMetricView.h"

@class OTMetricData;

typedef NS_ENUM(NSUInteger, OTAggregatorType) {
    OTAggregatorTypeNone,      // invalid type
    OTAggregatorTypeSum,       // record data value by adding them together
    OTAggregatorTypeLastValue, // record the latest data value
    OTAggregatorTypeHistogram, // record data to form a diagram
};

typedef NS_ENUM(NSUInteger, OTAggregatorTemporality) {
    OTAggregatorTemporalityUnspecified, // invalid type
    OTAggregatorTemporalityDelta,       // data value will reset after a single metric read intervale
    OTAggregatorTemporalityCumulative,  // data value will not reset during the app's life time
};

typedef NS_ENUM(NSUInteger, OTAggregatorMonotonic) {
    OTAggregatorMonotonicMonitonic,
    OTAggregatorMonotonicNonmonitonic, // indicate that the aggregator can accept value below zero
};

/// Aggregator helps aggregating measurements created by instruments
@protocol OTAggregatorProtocol <NSObject>

NS_ASSUME_NONNULL_BEGIN

typedef void (^OTObservableMeasurementBlock)(OTMeasurement *measurement);

/// type of the aggregation
@property (nonatomic, assign, readonly) OTAggregatorType type;

/// name of the aggregator, usually named after it's instrument, configurable by metic views
@property (nonatomic, copy) NSString *name;

/// description of the aggregator, usually it's the instrument' s description, configurable by metic views
@property (nonatomic, copy) NSString *descriptionInfo;

/// unit of the aggregator, usually it's the instrument' s unit, configurable by metic views
@property (nonatomic, copy) NSString *unit;

/// see temporality above
@property (nonatomic, assign) OTAggregatorTemporality temporality;

/// see monitonic above
@property (nonatomic, assign) OTAggregatorMonotonic monotonic;

/// value type of the aggregator, see value type above
@property (nonatomic, assign) OTNumericValueType valueType;

/// clock instance for aggregator in getting the proper time stamp.
@property (nonatomic, strong) id<OTClockProtocol> clock;

/// reservoir responsible for getting trace context from tracing module
@property (nonatomic, strong) id<OTExemplarReservoirProtocol> reservoir;

/// an array of data points wich already collected by the aggregator
@property (nonatomic, strong) OTSafeArray<OTMetricDataPoint *> *chartedDataPoints;

/// Keys that help aggregator to collect attributes only that is needed by user
@property (nonatomic, strong) OTSafeArray<NSString *> *attributeKyes;

/// this method will called when a instrument is about to take action
/// @param measurement measurement description
- (void)offerMeasurement:(OTMeasurement *)measurement;

/// Called by metric view, make aggregator to record a data point with exemplars recorded
- (void)recordDataPointAndCollectExemplars;

/// this method will called when metric reader is about to send metric data points to  exporter
- (OTMetricData *_Nullable)collectMetricData;

/// apply metric view's configuration to aggregator
/// @param params metric view params
- (void)applyConfigurationsFromMetricViewParams:(OTSafeDictionary<OTMetricViewKey, id> *)params;

NS_ASSUME_NONNULL_END

@end

#endif /* OTAggregatorProtocol_h */
