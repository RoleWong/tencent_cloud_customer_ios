//
//  OTLoggingJsonConverter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTLoggingJsonConverter.h"
#import "OTLogDataReportKeys.h"
#import "OTInstrumentationLibraryExportUnit.h"

@implementation OTLoggingJsonConverter

+ (NSDictionary *)resourceLogsDataFromRecords:(NSArray<OTLoggingRecordData *> *)recordsData resource:(OTResource *)resource {
    NSDictionary *resourceDict = resource.toJson ?: @{};
    NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    NSDictionary *recordDictionary = [self resourceRecordsInfoWithResourceDict:resourceDict records:recordsData logsKey:resource.logExportDataKey];
    [recordsArray addObject:recordDictionary];
    // 构建导出数据字典
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:recordsArray forKey:OTLogsDataKeyResourceLogsKey];
    return parameter;
}

+ (NSDictionary *)resourceRecordsInfoWithResourceDict:(NSDictionary *)resourceDict records:(NSArray<OTLoggingRecordData *> *)recordsData logsKey:(NSString *)logsKey {
    NSMutableDictionary *resourceRecords = [[NSMutableDictionary alloc] init];
    [resourceRecords setValue:resourceDict forKey:OTLogsDataKeyResource];
    [resourceRecords setValue:[self convertResourceLogsFromRecordsData:recordsData logsKey:logsKey] forKey:OTLogsDataKeyInstrumentationLibraryLogs];
    NSDictionary *outputSpans = [[NSDictionary alloc] initWithDictionary:resourceRecords];
    return outputSpans;
}

+ (NSArray *)convertResourceLogsFromRecordsData:(NSArray<OTLoggingRecordData *> *)recordsData logsKey:(NSString *)logsKey {
    NSDictionary *exportUnitDict = [OTInstrumentationLibraryExportUnit createExportUnitsFromTelemetryData:recordsData];
    NSArray *exportJsons = [OTInstrumentationLibraryExportUnit createJsonFormatDataWithExportUnitCollection:exportUnitDict
                                                                                              exportUnitKey:OTLogsDataKeyInstrumentationLibrary
                                                                                              exportDataKey:logsKey];
    return exportJsons;
}

@end
