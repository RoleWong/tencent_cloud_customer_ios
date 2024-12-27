//
//  OTAggregation.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAggregation.h"
#import "OTMetricDataReportKeys.h"
#import "OTMetricDataPoint.h"

@interface OTAggregation ()

@end

@implementation OTAggregation

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
    [self.metricDataPoints enumerateObjectsUsingBlock:^(OTMetricDataPoint *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *dataPointDict = [obj toJson];
        [dataPoints addObject:dataPointDict];
    }];
    [result setValue:dataPoints forKey:OTMetricReportKeyDataPoints];
    return result;
}

@end
