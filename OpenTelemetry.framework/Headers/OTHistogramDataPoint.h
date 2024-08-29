//
//  OTHistogramDataPoint.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricDataPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTHistogramDataPoint : OTMetricDataPoint

/// count is the number of values in the population. Must be non-negative. This value must be equal to the sum of the "count" fields in buckets if a
/// histogram is provided.
@property (nonatomic, assign) NSUInteger count;

/// sum of the values in the population. If count is zero then this field must be zero. This value must be equal to the sum of the "sum" fields in
/// buckets if a histogram is provided.
@property (nonatomic, strong) NSNumber *sum;

/// bucket_counts is an optional field contains the count values of histogram
/// for each bucket.
///
/// The sum of the bucket_counts must equal the value in the count field.
///
/// The number of elements in bucket_counts array must be by one greater than
/// the number of elements in explicit_bounds array.
@property (nonatomic, strong) NSArray<NSNumber *> *bucketCounts;

/// explicit_bounds specifies buckets with explicitly defined bounds for values.
///
/// This defines size(explicit_bounds) + 1 (= N) buckets. The boundaries for
/// bucket at index i are:
///
/// (-infinity, explicit_bounds[i]] for i == 0
/// (explicit_bounds[i-1], explicit_bounds[i]] for 0 < i < N-1
/// (explicit_bounds[i], +infinity) for i == N-1
///
/// The values in the explicit_bounds array must be strictly increasing.
///
/// Histogram buckets are inclusive of their upper boundary, except the last
/// bucket where the boundary is at infinity. This format is intentionally
/// compatible with the OpenMetrics histogram definition.
@property (nonatomic, strong) NSArray<NSNumber *> *explicitBounds;

@end

NS_ASSUME_NONNULL_END
