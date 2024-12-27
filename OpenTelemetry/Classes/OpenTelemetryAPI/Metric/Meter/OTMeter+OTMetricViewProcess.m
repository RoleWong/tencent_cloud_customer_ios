//
//  OTMeter+OTMetricViewProcess.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMeter+OTMetricViewProcess.h"

@implementation OTMeter (OTMetricViewProcess)

- (OTMetricView *)matchedViewFromMetricViews:(OTSafeArray<OTMetricView *> *)metricViews measurement:(OTMeasurement *)measurement {
    OTSafeArray *matchedMetricViews = [[OTSafeArray alloc] init];
    [metricViews enumerateObjectsUsingBlock:^(OTMetricView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isMatchedWithMeasurement:measurement libraryInfo:self.libraryInfo]) {
            [matchedMetricViews addObject:obj];
        }
    }];
    return matchedMetricViews.lastObject;
}

@end
