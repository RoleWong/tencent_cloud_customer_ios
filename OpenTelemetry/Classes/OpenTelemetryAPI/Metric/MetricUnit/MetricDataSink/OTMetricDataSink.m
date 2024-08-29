//
//  OTMetricDataSink.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright (c) 2021 ravendeng. All rights reserved.
//

#import "OTMetricDataSink.h"
#import "OTMetricData.h"
#import "OTMetricDataPoint.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTmetricDataReportKeys.h"

@implementation OTMetricDataSink

- (instancetype)init {
    if (self = [super init]) {
        _metricDatas = [[OTSafeArray alloc] init];
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    NSDictionary *instrumentationLibrary = [self.libraryInfo toJson];

    NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
    [self.metricDatas enumerateObjectsUsingBlock:^(OTMetricData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *metric = [obj toJson];
        [dataPoints addObject:metric];
    }];
    [result setValue:instrumentationLibrary forKey:OTMetricReportKeyInstrumentationLibrary];
    [result setValue:dataPoints forKey:OTMetricReportKeyMetrics];
    [result setValue:self.libraryInfo.schemaUrl forKey:OTMetricReportKeySchemaURL];

    return result;
}

@end
