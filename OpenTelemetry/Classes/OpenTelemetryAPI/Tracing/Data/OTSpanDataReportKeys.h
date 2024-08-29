//
//  OTSpanDataReportKeys.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Span

typedef NSString *OTSpanDataKey NS_STRING_ENUM;

FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyTraceId;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeySpanId;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyName;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyParentSpanId;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyKind;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyStartTimeUnixNano;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyEndTimeUnixNano;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyAttributes;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyEvents;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyStatus;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyLinks;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyTraceState;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDroppedAttributesKey;

#pragma mark -Event

FOUNDATION_EXPORT OTSpanDataKey const OTSpanEventTimeUnixNanoKey;

#pragma mark - InstrumentationLibrary

FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyInstrumentationLibrary;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeySpans;

#pragma mark - ResourceSpans

FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyInstrumentationLibrarySpans;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyResource;
FOUNDATION_EXPORT OTSpanDataKey const OTSpanDataKeyResourceSpans;

NS_ASSUME_NONNULL_END
