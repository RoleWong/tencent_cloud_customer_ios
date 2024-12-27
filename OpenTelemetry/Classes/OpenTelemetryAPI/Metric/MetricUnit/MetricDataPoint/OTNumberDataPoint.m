//
//  OTNumberDataPoint.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTNumberDataPoint.h"

#import "OTMetricDataReportKeys.h"

@interface OTNumberDataPoint ()

@end

@implementation OTNumberDataPoint

- (instancetype)init {
    if (self = [super init]) {
        _value = @0;
    }
    return self;
}

- (NSTimeInterval)doubleValue {
    return self.value.doubleValue;
}

- (NSInteger)longValue {
    return self.value.integerValue;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[super toJson]];
    if (self.valueType == OTNumericValueTypeLong) {
        [result setValue:@(self.longValue) forKey:OTMetricReportKeyAsInt];
    } else if (self.valueType == OTNumericValueTypeDouble) {
        [result setValue:@(self.doubleValue) forKey:OTMetricReportKeyAsDouble];
    }
    return result;
}

- (BOOL)isValidDataPoint {
    return self.value.doubleValue != 0;
}

- (OTDataPointFlag)flag {
    return OTDataPointFlag_None;
}

@end
