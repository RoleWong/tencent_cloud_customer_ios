//
//  OTHistogramAggregator.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregator.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTHistogramAggregator : OTAggregator

/// define the explicitBounds of the bucket, records that within the range of bounds will be collected.
@property (nonatomic, strong, readonly) OTSafeArray<NSNumber *> *userDefinedExplicitBounds;

/// initialize an histogram aggregator
/// @param bounds define the explicitBounds of the bucket, records that within the range of bounds will be collected.
- (instancetype)initWithExplicitBounds:(OTSafeArray<NSNumber *> *)bounds NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
