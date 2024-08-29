//
//  OTHistogramAggregation.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAggregation.h"

NS_ASSUME_NONNULL_BEGIN

/// this is a metric data contianer for metric data reporting
@interface OTHistogramAggregation : OTAggregation

@property (nonatomic, assign) OTAggregatorTemporality temporality;

@end

NS_ASSUME_NONNULL_END
