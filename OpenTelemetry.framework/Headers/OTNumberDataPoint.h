//
//  OTNumberDataPoint.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricDataPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTNumberDataPoint : OTMetricDataPoint

@property (nonatomic, assign, readonly) NSTimeInterval doubleValue;

@property (nonatomic, assign, readonly) NSInteger longValue;

@property (nonatomic, strong) NSNumber *value;

@end

NS_ASSUME_NONNULL_END
