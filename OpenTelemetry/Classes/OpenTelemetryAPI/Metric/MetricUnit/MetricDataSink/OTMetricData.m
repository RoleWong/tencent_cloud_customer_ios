//
//  OTMetric.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricData.h"
#import "OTMetricDataReportKeys.h"

@implementation OTMetricData

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue:self.name forKey:OTMetricReportKeyName];
    [result setValue:self.unit forKey:OTMetricReportKeyUnit];
    [result setValue:self.descriptionInfo forKey:OTMetricReportKeyDescription];
    NSDictionary *aggregatorDict = [self.aggregation toJson];
    if (self.aggregation.type == OTAggregatorTypeSum) {
        [result setValue:aggregatorDict forKey:OTMetricReportKeySum];
    } else if (self.aggregation.type == OTAggregatorTypeHistogram) {
        [result setValue:aggregatorDict forKey:OTMetricReportKeyHistogram];
    } else if (self.aggregation.type == OTAggregatorTypeLastValue) {
        [result setValue:aggregatorDict forKey:OTMetricReportKeyGuage];
    }
    return result;
}

@end
