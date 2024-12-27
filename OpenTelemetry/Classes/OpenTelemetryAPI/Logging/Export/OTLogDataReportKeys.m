//
//  OTLogDataReportKeys.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTLogDataReportKeys.h"

#pragma mark - OTLoggingAnyValue

NSString *const OTLoggingAnyValueType_string = @"string_value";
NSString *const OTLoggingAnyValueType_bool = @"bool_value";
NSString *const OTLoggingAnyValueType_int = @"int_value";
NSString *const OTLoggingAnyValueType_double = @"double_value";
NSString *const OTLoggingAnyValueType_array = @"array_value";
NSString *const OTLoggingAnyValueType_kvlist = @"kvlist_value";

#pragma mark - OTLoggingKeyValue

NSString *const OTLoggingKeyValue_key = @"key";
NSString *const OTLoggingKeyValue_value = @"value";
NSString *const OTLoggingKeyValue_values = @"values";

#pragma mark - OTLoggingRecord

NSString *const OTLoggingRecordKey_timestamp = @"time_unix_nano";
NSString *const OTLoggingRecordKey_spanId = @"span_id";
NSString *const OTLoggingRecordKey_name = @"name";
NSString *const OTLoggingRecordKey_traceId = @"trace_id";
NSString *const OTLoggingRecordKey_traceFlags = @"flags";
NSString *const OTLoggingRecordKey_severityText = @"severity_text";
NSString *const OTLoggingRecordKey_severity = @"severity_number";
NSString *const OTLoggingRecordKey_body = @"body";
NSString *const OTLoggingRecordKey_attributes = @"attributes";

#pragma mark - OTLoggingResource

NSString *const OTLogsDataKeyInstrumentationLibraryLogs = @"instrumentation_library_logs";
NSString *const OTLogsDataKeyInstrumentationLibrary = @"instrumentation_library";
NSString *const OTLogsDataKeyLogs = @"logs";
/// 与 android 端对齐 log 的 key 值
NSString *const OTLogsDataKeyLogRecords = @"log_records";
NSString *const OTLogsDataKeyResource = @"resource";
NSString *const OTLogsDataKeyResourceLogsKey = @"resource_logs";
