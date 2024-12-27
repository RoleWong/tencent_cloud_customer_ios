//
//  OTAggregator+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTAggregator.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"
#import "OTMetricDataPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTAggregator (Private)

@property (nonatomic, strong) OTSafeDictionary<NSString *, OTMetricDataPoint *> *aggregatingDataPoints;

@end

NS_ASSUME_NONNULL_END
