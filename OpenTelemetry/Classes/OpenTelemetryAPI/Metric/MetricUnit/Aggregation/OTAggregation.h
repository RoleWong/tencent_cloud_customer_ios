//
//  OTAggregation.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTJsonConvertible.h"
#import "OTAggregatorProtocol.h"
#import "OTSafeArray.h"

@class OTMetricDataPoint;

NS_ASSUME_NONNULL_BEGIN

/// this is a data model responsible for contrusting exportable data
@interface OTAggregation : OTBaseObject <OTJsonConvertible>

/// type of the aggregation, see OTAggregatorProtocol
@property (nonatomic, assign) OTAggregatorType type;

/// metric data points recorded by certain aggregator
@property (nonatomic, strong) OTSafeArray<OTMetricDataPoint *> *metricDataPoints;

@end

NS_ASSUME_NONNULL_END
