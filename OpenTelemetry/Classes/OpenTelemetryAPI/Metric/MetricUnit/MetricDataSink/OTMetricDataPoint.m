//
//  OTMetricData.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricDataPoint.h"
#import "OTMetricDataReportKeys.h"
#import "OTAttribute.h"
#import "OTExemplar.h"
#import "NSObject+OTJsonTools.h"

@interface OTMetricDataPoint ()

@end

@implementation OTMetricDataPoint

- (OTDataPointFlag)flag {
    NSAssert(NO, @"This is an abstract class, %s must be implemented by subclasses", __FUNCTION__);
    return OTDataPointFlag_NoRecordedValue;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    NSMutableArray *attributesJson = [[NSMutableArray alloc] init];

    [self.attributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [attributesJson addObject:[obj toJson]];
    }];

    [result setValue:attributesJson forKey:OTMetricReportKeyAttributes];
    NSString *startTimeNumber = [NSString stringWithFormat:@"%lld", (uint64_t)self.startTimeUnixNano];
    [result setValue:startTimeNumber forKey:OTMetricReportKeyStartTimeUnixNano];
    NSString *timeNumber = [NSString stringWithFormat:@"%lld", (uint64_t)self.timeUnixNano];
    [result setValue:timeNumber forKey:OTMetricReportKeyTimeUnixNano];
    NSMutableArray *exemplars = [[NSMutableArray alloc] init];
    [self.exemplars enumerateObjectsUsingBlock:^(OTExemplar *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [exemplars addObject:[obj toJson]];
    }];
    [result setValue:exemplars forKey:OTMetricReportKeyExemplars];
    return result;
}

- (NSString *)description {
    NSError *descriptionError = nil;
    NSString *jsonString = [[self toJson] ot_jsonStringOnelineWithError:nil];
    if (descriptionError) {
        jsonString = descriptionError.description;
    }
    return jsonString;
}

- (OTSafeArray<OTExemplar *> *)exemplars {
    if (!_exemplars) {
        _exemplars = [[OTSafeArray alloc] init];
    }
    return _exemplars;
}

- (BOOL)isValidDataPoint {
    NSAssert(NO, @"This is an abstract class, %s must be implemented by subclasses", __FUNCTION__);
    return NO;
}

@end
