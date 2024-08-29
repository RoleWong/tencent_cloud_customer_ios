//
//  OTSpanDataReportKeys.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanDataReportKeys.h"

#pragma mark - Span

OTSpanDataKey const OTSpanDataKeyTraceId = @"trace_id";
OTSpanDataKey const OTSpanDataKeySpanId = @"span_id";
OTSpanDataKey const OTSpanDataKeyName = @"name";
OTSpanDataKey const OTSpanDataKeyParentSpanId = @"parent_span_id";
OTSpanDataKey const OTSpanDataKeyKind = @"kind";
OTSpanDataKey const OTSpanDataKeyStartTimeUnixNano = @"start_time_unix_nano";
OTSpanDataKey const OTSpanDataKeyEndTimeUnixNano = @"end_time_unix_nano";
OTSpanDataKey const OTSpanDataKeyAttributes = @"attributes";
OTSpanDataKey const OTSpanDataKeyEvents = @"events";
OTSpanDataKey const OTSpanDataKeyStatus = @"status";
OTSpanDataKey const OTSpanDataKeyLinks = @"links";
OTSpanDataKey const OTSpanDataKeyTraceState = @"trace_state";
OTSpanDataKey const OTSpanDroppedAttributesKey = @"dropped_attributes_count";

#pragma mark - Event

OTSpanDataKey const OTSpanEventTimeUnixNanoKey = @"time_unix_nano";

#pragma mark - InstrumentationLibrary
OTSpanDataKey const OTSpanDataKeyInstrumentationLibrary = @"instrumentation_library";
OTSpanDataKey const OTSpanDataKeySpans = @"spans";

#pragma mark - ResourceSpans
OTSpanDataKey const OTSpanDataKeyInstrumentationLibrarySpans = @"instrumentation_library_spans";
OTSpanDataKey const OTSpanDataKeyResource = @"resource";
OTSpanDataKey const OTSpanDataKeyResourceSpans = @"resourceSpans";
