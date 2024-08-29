//
//  OTSumaggregator.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregator.h"

NS_ASSUME_NONNULL_BEGIN

/// Sum Aggregation This Aggregation informs the SDK to collect: The arithmetic sum of Measurement values.
@interface OTSumAggregator : OTAggregator

@end

NS_ASSUME_NONNULL_END
