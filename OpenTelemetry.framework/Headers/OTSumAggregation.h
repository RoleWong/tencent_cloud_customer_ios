//
//  OTSumAggregation.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregation.h"

NS_ASSUME_NONNULL_BEGIN

/// this is a metric data contianer for metric data reporting
@interface OTSumAggregation : OTAggregation

@property (nonatomic, assign) OTAggregatorTemporality temporality;

@property (nonatomic, assign) OTAggregatorMonotonic monotonic;

@end

NS_ASSUME_NONNULL_END
