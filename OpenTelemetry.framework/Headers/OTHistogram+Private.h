//
//  OTHistogram+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTHistogram.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTHistogram (Private)

/// initaial buckets for histogram to describe how the recorded value should stored in aggregator
@property (nonatomic, strong) OTSafeArray<NSNumber *> *buckets;

@end

NS_ASSUME_NONNULL_END
