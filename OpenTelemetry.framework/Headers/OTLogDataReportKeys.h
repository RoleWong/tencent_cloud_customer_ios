//
//  OTLogDataReportKeys.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - OTLoggingAnyValue

FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_string;
FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_bool;
FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_int;
FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_double;
FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_array;
FOUNDATION_EXPORT NSString *const OTLoggingAnyValueType_kvlist;

#pragma mark - OTLoggingKeyValue

FOUNDATION_EXPORT NSString *const OTLoggingKeyValue_key;
FOUNDATION_EXPORT NSString *const OTLoggingKeyValue_value;
FOUNDATION_EXPORT NSString *const OTLoggingKeyValue_values;

#pragma mark - OTLoggingRecord

typedef NSString *OTLoggingRecordKey NS_STRING_ENUM;

FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_timestamp;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_traceId;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_spanId;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_name;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_traceFlags;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_severityText;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_severity;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_body;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_resource;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLoggingRecordKey_attributes;

#pragma mark - OTLoggingResource

FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyInstrumentationLibraryLogs;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyInstrumentationLibrary;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyLogs;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyLogRecords;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyResource;
FOUNDATION_EXPORT OTLoggingRecordKey const OTLogsDataKeyResourceLogsKey;

NS_ASSUME_NONNULL_END
