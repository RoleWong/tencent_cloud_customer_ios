//
//  OTExemplar.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/21.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTExemplar.h"
#import "OTMetricDataReportKeys.h"
#import "OTAttribute.h"

@implementation OTExemplar

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSMutableArray *filteredAttributes = [[NSMutableArray alloc] init];
    [self.filteredAttributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [filteredAttributes addObject:[obj toJson]];
    }];
    [result setValue:filteredAttributes forKey:OTMetricReportKeyFilteredAttributes];

    NSString *timeString = [NSString stringWithFormat:@"%lld", (uint64_t)self.timeUnixNano];
    [result setValue:timeString forKey:OTMetricReportKeyTimeUnixNano];

    if (self.valueType == OTNumericValueTypeLong) {
        [result setValue:self.value forKey:OTMetricReportKeyAsInt];
    } else if (self.valueType == OTNumericValueTypeDouble) {
        [result setValue:self.value forKey:OTMetricReportKeyAsDouble];
    }

    [result setValue:self.spanId forKey:OTMetricReportKeySpanId];
    [result setValue:self.traceId forKey:OTMetricReportKeyTraceId];

    return result;
}

@end
