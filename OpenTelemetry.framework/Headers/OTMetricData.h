//
//  OTMetric.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregation.h"
#import "OTJsonConvertible.h"

NS_ASSUME_NONNULL_BEGIN

/// metricdata is an data container for metric data reporting
@interface OTMetricData : OTBaseObject <OTJsonConvertible>

/// name
@property (nonatomic, copy) NSString *name;

/// unit
@property (nonatomic, copy) NSString *unit;

/// description
@property (nonatomic, copy) NSString *descriptionInfo;

/// the aggregation
@property (nonatomic, strong) OTAggregation *aggregation;

@end

NS_ASSUME_NONNULL_END
