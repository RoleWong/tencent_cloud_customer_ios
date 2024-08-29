//
//  OTHistogramAggregation.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTHistogramAggregation.h"
#import "OTMetricDataReportKeys.h"
#import "OTAggregatorProtocol.h"

@implementation OTHistogramAggregation

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTAggregatorTypeHistogram;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[super toJson]];
    [result setValue:@(self.temporality) forKey:OTMetricReportKeyAggregationTemporality];
    return result;
}

@end
