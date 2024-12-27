//
//  OTHistogram.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrument.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTHistogram : OTInstrument

/// initaial buckets for histogram to describe how the recorded value should stored in aggregator
@property (nonatomic, strong, readonly) OTSafeArray<NSNumber *> *buckets;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Record a long value to histogram
/// @param value value type long
/// @param attributes attributes
- (void)recordLongValue:(NSInteger)value attributes:(NSDictionary<NSString *, NSString *> *_Nullable)attributes;

/// Record a double value to histogram
/// @param value value type double
/// @param attributes attributes
- (void)recordDoubleValue:(NSTimeInterval)value attributes:(NSDictionary<NSString *, NSString *> *_Nullable)attributes;

@end

NS_ASSUME_NONNULL_END
