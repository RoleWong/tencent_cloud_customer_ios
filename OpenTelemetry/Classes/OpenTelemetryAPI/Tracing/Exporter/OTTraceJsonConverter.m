//
//  OTTraceJsonConverter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTTraceJsonConverter.h"
#import "OTInstrumentationLibraryExportUnit.h"
#import "OTSpanDataReportKeys.h"

@implementation OTTraceJsonConverter

+ (NSArray *)convertSpansToReadableJsonObjectArray:(NSArray<OTSpanData *> *)spansData {
    NSDictionary *exportUnitDict = [OTInstrumentationLibraryExportUnit createExportUnitsFromTelemetryData:spansData];
    NSArray *exportJsons = [OTInstrumentationLibraryExportUnit createJsonFormatDataWithExportUnitCollection:exportUnitDict
                                                                                              exportUnitKey:OTSpanDataKeyInstrumentationLibrary
                                                                                              exportDataKey:OTSpanDataKeySpans];
    return exportJsons;
}

/// construcnt tracing data in json format
/// @param spansData spans data collected by processor
/// @param resource resouce of the tracer provider
+ (NSDictionary *)traceDataWithSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource {
    // Exporter will export trace data from the very same provider, meaning they share the same resource
    NSDictionary *resourceDict = resource.toJson ? resource.toJson : @{};
    // Spans may came from different tracers, distinguish them by instrumentation library infos.
    NSMutableArray *spansArray = [[NSMutableArray alloc] init];
    NSDictionary *spanDictionary = [self resourceSpansInfoWithResourceDict:resourceDict spansData:spansData];
    [spansArray addObject:spanDictionary];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:spansArray forKey:OTSpanDataKeyResourceSpans];
    return parameter;
}

/// Construct resource span data in json format
/// @param resourceDict the resouce data in json format
/// @param spansData the spansdata
+ (NSDictionary *)resourceSpansInfoWithResourceDict:(NSDictionary *)resourceDict spansData:(NSArray<OTSpanData *> *)spansData {
    NSMutableDictionary *resourceSpans = [[NSMutableDictionary alloc] init];
    [resourceSpans setValue:resourceDict forKey:OTSpanDataKeyResource];
    [resourceSpans setValue:[self convertSpansToReadableJsonObjectArray:spansData] forKey:OTSpanDataKeyInstrumentationLibrarySpans];
    NSDictionary *outputSpans = [[NSDictionary alloc] initWithDictionary:resourceSpans];
    return outputSpans;
}

@end
