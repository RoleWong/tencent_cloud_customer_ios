//
//  OTHistogramDataPoint.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTHistogramDataPoint.h"
#import "OTMetricDataReportKeys.h"

@implementation OTHistogramDataPoint

- (OTDataPointFlag)flag {
    if (self.bucketCounts.count == 0) {
        return OTDataPointFlag_NoRecordedValue;
    } else {
        return OTDataPointFlag_None;
    }
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[super toJson]];
    NSNumber *countNumber = [NSNumber numberWithUnsignedInteger:self.count];
    [result setValue:countNumber forKey:OTMetricReportKeyCount];
    [result setValue:self.sum forKey:OTMetricReportKeySum];
    [result setValue:self.bucketCounts forKey:OTMetricReportKeyBucketCounts];
    [result setValue:self.explicitBounds forKey:OTMetricReportKeyExplicitBounds];
    return result;
}

- (BOOL)isValidDataPoint {
    return self.sum.doubleValue > 0;
}

@end
