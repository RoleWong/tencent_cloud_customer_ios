//
//  OTaggregatorFactory.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAggregatorProtocol.h"
#import "OTInstrument.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTaggregatorFactory : NSObject

/// create an aggregator for sum aggrgation
/// @param temporality temporality description
+ (id<OTAggregatorProtocol>)createSumAggregatorWithTemporality:(OTAggregatorTemporality)temporality;

/// create an aggregator for  last value aggrgation
/// @param temporality temporality description
+ (id<OTAggregatorProtocol>)createLastValueAggregatorWithTemporality:(OTAggregatorTemporality)temporality;

/// an aggregator for histogram aggrgation
/// @param temporality temporality description
/// @param buckets bukets define how the histogram will collect datapoints
+ (id<OTAggregatorProtocol>)createHistogramAggregatorWithTemporality:(OTAggregatorTemporality)temporality buckets:(OTSafeArray<NSNumber *> *)buckets;

/// an aggregator for instrument's default aggrgation
/// @param instrument instrument description
+ (id<OTAggregatorProtocol> _Nullable)createDefaultAggregatorForInstrument:(OTInstrument *)instrument;

@end

NS_ASSUME_NONNULL_END
