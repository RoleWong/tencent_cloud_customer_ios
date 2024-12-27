//
//  OTMeter+OTMetricViewProcess.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMeter.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMeter (OTMetricViewProcess)

/// find suitable view for measurement
/// @param metricViews metricViews description
/// @param measurement measurement description
- (OTMetricView *_Nullable)matchedViewFromMetricViews:(OTSafeArray<OTMetricView *> *)metricViews measurement:(OTMeasurement *)measurement;

@end

NS_ASSUME_NONNULL_END
