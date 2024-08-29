//
//  OTMetricView.h
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTSafeDictionary.h"

@class OTMeasurement, OTInstrumentationLibraryInfo;

#pragma mark - MetricViewKeys

NS_ASSUME_NONNULL_BEGIN

typedef NSString *OTMetricViewKey NS_STRING_ENUM;
typedef NSString *OTCriteriaKey NS_STRING_ENUM;

#pragma mark - Instrument selection criteria

/// keys that help filter the needed measurement, represent as NSString
FOUNDATION_EXPORT OTCriteriaKey const OTCriteriaKeyInsrumentName;
/// keys that help filter the needed measurement, represent as NSString
FOUNDATION_EXPORT OTCriteriaKey const OTCriteriaKeyMeterName;
/// keys that help filter the needed measurement, represent as NSString
FOUNDATION_EXPORT OTCriteriaKey const OTCriteriaKeyMeterVersion;
/// keys that help filter the needed measurement, represent as NSString
FOUNDATION_EXPORT OTCriteriaKey const OTCriteriaKeyMeterSchemaURL;
/// represent as ANY object, if this key was found in criteria, it means to apply to all measurement
FOUNDATION_EXPORT OTCriteriaKey const OTCriteriaKeyAny;

#pragma mark - Instrument Configuration
/// The name of the View (optional). If not provided, the Instrument name would be used by default. This will be used as the name of the metrics
/// stream.
FOUNDATION_EXPORT OTMetricViewKey const OTMetricViewKeyName;
/// The description. If not provided, the Instrument description would be used by default.
FOUNDATION_EXPORT OTMetricViewKey const OTMetricViewKeyDescription;
/// A list of attribute keys (optional). If provided, the attributes that are not in the list will be ignored. If not provided, all the attribute keys
/// will be used by default (TODO: once the Hint API is available, the default behavior should respect the Hint if it is available).
FOUNDATION_EXPORT OTMetricViewKey const OTMetricViewKeyAttributeKeys;
/// The aggregation (optional) to be used. If not provided, the SDK SHOULD apply a default aggregation. If the aggregation has temporality, the SDK
/// SHOULD use the temporality override rules to determine the aggregation temporality.
FOUNDATION_EXPORT OTMetricViewKey const OTMetricViewKeyAggregator;
/// The exemplar_reservoir (optional) to use for storing exemplars. This should be a factory or callback similar to aggregation which allows different
/// reservoirs to be chosen by the aggregation.
FOUNDATION_EXPORT OTMetricViewKey const OTMetricViewKeyExemplarReservoir;

#pragma mark - Error

FOUNDATION_EXPORT NSNotificationName const OTMetricViewErrorDomain;

typedef NS_ENUM(NSUInteger, OTMetricViewErrorStatus) {
    OTMetricViewErrorStatusNoCriteria = 1001,
};

@interface OTMetricView : NSObject

/// key-value pairs that help filter the qualified instruments
@property (nonatomic, copy, readonly) OTSafeDictionary<OTCriteriaKey, id> *criteria;

/// the configurations that apply to the qualified instruments
@property (nonatomic, copy, readonly) OTSafeDictionary<OTMetricViewKey, id> *params;

/// initialize an metric view instance
/// @param criteria key-value pairs that help filter the qualified instruments
/// @param params the configurations that apply to the qualified instruments
- (instancetype)initWithCriteria:(NSDictionary<OTCriteriaKey, id> *)criteria params:(NSDictionary<OTMetricViewKey, id> *)params;

/// helps define the configuration passed by user is qualify for metric collection
/// @param error error description
- (BOOL)isValidMetricViewWithError:(NSError **_Nullable)error;

/// to decide whether the metric view will be applied to certain measurement and instrumentationinfo
/// @param measurement measurement description
/// @param libraryInfo libraryInfo description
- (BOOL)isMatchedWithMeasurement:(OTMeasurement *)measurement libraryInfo:(OTInstrumentationLibraryInfo *)libraryInfo;

@end

NS_ASSUME_NONNULL_END
