//
//  OTSumAggregation.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSumAggregation.h"
#import "OTNumberDataPoint.h"
#import "OTMetricDataReportKeys.h"
#import "OTAggregatorProtocol.h"

@implementation OTSumAggregation

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTAggregatorTypeSum;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[super toJson]];
    BOOL isMonotonic = self.monotonic == OTAggregatorMonotonicMonitonic;
    [result setValue:[NSNumber numberWithBool:isMonotonic] forKey:OTMetricReportKeyIsMonotonic];
    [result setValue:@(self.temporality) forKey:OTMetricReportKeyAggregationTemporality];
    return result;
}

@end
