//
//  OTMetricJsonConverter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTMetricJsonConverter.h"
#import "OTMetricDataReportKeys.h"

@implementation OTMetricJsonConverter

+ (NSDictionary *)metricParametersToExport:(OTSafeArray<OTMetricDataSink *> *)batchedMetricData resource:(OTResource *)resource {
    // retrive all metric data points from meter to construct a meter data struct
    NSMutableArray *metricDataSinkList = [[NSMutableArray alloc] init];
    [batchedMetricData enumerateObjectsUsingBlock:^(OTMetricDataSink *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *metricDataSink = [obj toJson];
        [metricDataSinkList addObject:metricDataSink];
    }];
    // construnct a data struct with resource info and meter info
    NSMutableDictionary *metricParameter = [[NSMutableDictionary alloc] init];
    [metricParameter setValue:metricDataSinkList forKey:OTMetricReportKeyInstrumentationLibraryMetrics];
    NSDictionary *resourceDict = [resource toJson];
    [metricParameter setValue:resourceDict forKey:OTMetricReportKeyResource];
    NSString *schemaUrl = [resource stringValueForKey:OTMetricReportKeySchemaURL];
    [metricParameter setValue:schemaUrl forKey:OTMetricReportKeySchemaURL];
    // put it in an array
    NSMutableArray *metricParameterArray = [[NSMutableArray alloc] init];
    [metricParameterArray addObject:metricParameter];
    // construct final output data
    NSMutableDictionary *resourceMetrics = [[NSMutableDictionary alloc] init];
    [resourceMetrics setValue:metricParameterArray forKey:OTMetricReportKeyResourceMetrics];

    return resourceMetrics;
}

@end
