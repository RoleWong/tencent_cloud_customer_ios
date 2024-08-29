//
//  OTMetricDataReportKeys.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMetricDataReportKeys.h"

NSString *const OTMetricReportKeyResourceMetrics = @"resource_metrics";
NSString *const OTMetricReportKeyResource = @"resource";
NSString *const OTMetricReportKeyInstrumentationLibraryMetrics = @"instrumentation_library_metrics";
NSString *const OTMetricReportKeySchemaURL = @"schema_url";
NSString *const OTMetricReportKeyInstrumentationLibrary = @"instrumentation_library";
NSString *const OTMetricReportKeyMetrics = @"metrics";
NSString *const OTMetricReportKeyName = @"name";
NSString *const OTMetricReportKeyUnit = @"unit";
NSString *const OTMetricReportKeyDescription = @"description";
NSString *const OTMetricReportKeySum = @"sum";
NSString *const OTMetricReportKeyAggregationTemporality = @"aggregation_temporality";
NSString *const OTMetricReportKeyIsMonotonic = @"is_monotonic";
NSString *const OTMetricReportKeyGuage = @"gauge";
NSString *const OTMetricReportKeyHistogram = @"histogram";
NSString *const OTMetricReportKeySummary = @"summary";
NSString *const OTMetricReportKeyDataPoints = @"data_points";
NSString *const OTMetricReportKeyAttributes = @"attributes";
NSString *const OTMetricReportKeyStartTimeUnixNano = @"start_time_unix_nano";
NSString *const OTMetricReportKeyTimeUnixNano = @"time_unix_nano";
NSString *const OTMetricReportKeyExemplars = @"exemplars";
NSString *const OTMetricReportKeyAsDouble = @"as_double";
NSString *const OTMetricReportKeyAsInt = @"as_int";
NSString *const OTMetricReportKeyFilteredAttributes = @"filtered_attributes";
NSString *const OTMetricReportKeySpanId = @"span_id";
NSString *const OTMetricReportKeyTraceId = @"trace_id";
NSString *const OTMetricReportKeyCount = @"count";
NSString *const OTMetricReportKeyBucketCounts = @"bucket_counts";
NSString *const OTMetricReportKeyExplicitBounds = @"explicit_bounds";
