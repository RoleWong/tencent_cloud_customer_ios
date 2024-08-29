//
//  OTMetricJsonConverter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTMetricDataSink.h"
#import "OTResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMetricJsonConverter : NSObject

/// convert metricDatas and resource to json format
/// @param batchedMetricData metricdatas
/// @param resource resource
+ (NSDictionary *)metricParametersToExport:(OTSafeArray<OTMetricDataSink *> *)batchedMetricData resource:(OTResource *)resource;

@end

NS_ASSUME_NONNULL_END
