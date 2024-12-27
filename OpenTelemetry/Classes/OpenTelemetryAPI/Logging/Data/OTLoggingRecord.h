//
//  OTLoggingRecord.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/17.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTJsonConvertible.h"
#import "OTClockProtocol.h"
#import "OTAttribute.h"
#import "OTLoggingAnyValue.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTLogDataReportKeys.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTLoggingRecordSeverity) {
    OTLoggingRecordSeverityUndefined = 0,
    OTLoggingRecordSeverityTrace,
    OTLoggingRecordSeverityTrace2,
    OTLoggingRecordSeverityTrace3,
    OTLoggingRecordSeverityTrace4,
    OTLoggingRecordSeverityDebug,
    OTLoggingRecordSeverityDebug2,
    OTLoggingRecordSeverityDebug3,
    OTLoggingRecordSeverityDebug4,
    OTLoggingRecordSeverityInfo,
    OTLoggingRecordSeverityInfo2,
    OTLoggingRecordSeverityInfo3,
    OTLoggingRecordSeverityInfo4,
    OTLoggingRecordSeverityWarn,
    OTLoggingRecordSeverityWarn2,
    OTLoggingRecordSeverityWarn3,
    OTLoggingRecordSeverityWarn4,
    OTLoggingRecordSeverityError,
    OTLoggingRecordSeverityError2,
    OTLoggingRecordSeverityError3,
    OTLoggingRecordSeverityError4,
    OTLoggingRecordSeverityFatal,
    OTLoggingRecordSeverityFatal2,
    OTLoggingRecordSeverityFatal3,
    OTLoggingRecordSeverityFatal4
};

@interface OTLoggingRecord : OTBaseObject <OTJsonConvertible>

/**
 Request trace id as defined in W3C Trace Context. Can be set for logs that are part of request processing and have an assigned trace id. This field
 is optional.
 */
@property (nonatomic, copy) NSString *traceId;

/**
 Span id. Can be set for logs that are part of a particular processing span. If SpanId is present TraceId SHOULD be also present. This field is
 optional.
 */
@property (nonatomic, copy) NSString *spanId;

/**
 Trace flag as defined in W3C Trace Context specification. At the time of writing the specification defines one flag - the SAMPLED flag. This field is
 optional.
 */
@property (nonatomic, assign) NSInteger traceFlags;

/**
 This is the original string representation of the severity as it is known at the source. If this field is missing and SeverityNumber is present then
 the short name that corresponds to the SeverityNumber may be used as a substitution. This field is optional.
 */
@property (nonatomic, copy, nullable) NSString *severityText;

/**
 Numerical value of the severity, normalized to values described in this document. This field is optional.
 SeverityNumber is an integer number. Smaller numerical values correspond to less severe events (such as debug events), larger numerical values
 correspond to more severe events (such as errors and critical events). The following table defines the meaning of SeverityNumber value:

 SeverityNumber range    Range name    Meaning
 1-4        TRACE       A fine-grained debugging event. Typically disabled in default configurations.
 5-8        DEBUG      A debugging event.
 9-12      INFO          An informational event. Indicates that an event happened.
 13-16    WARN        A warning event. Not an error but is likely more important than an informational event.
 17-20    ERROR     An error event. Something went wrong.
 21-24    FATAL        A fatal error such as application or system crash.
 */
@property (nonatomic, assign) OTLoggingRecordSeverity severity;

/**
 Short event identifier that does not contain varying parts. Name describes what happened. Recommended to be no longer than 50 characters. Not
 guaranteed to be unique in any way. Typically used for filtering and grouping purposes in backends. This field is optional.
 */
@property (nonatomic, copy, nullable) NSString *name;

/**
 A value containing the body of the log record (see the description of any type above). Can be for example a human-readable string message (including
 multi-line) describing the event in a free form or it can be a structured data composed of arrays and maps of other values. Can vary for each
 occurrence of the event coming from the same source. This field is optional.
 */
@property (nonatomic, strong) OTLoggingAnyValue *body;

/**
 Additional information about the specific event occurrence. Unlike the Resource field, which is fixed for a particular source, Attributes can vary
 for each occurrence of the event coming from the same source. Can contain information about the request context (other than TraceId/SpanId). SHOULD
 follow OpenTelemetry semantic conventions for Attributes. This field is optional.
 */
@property (nonatomic, copy) NSArray<OTAttribute *> *attributes;

/// the instrumentationLibraryInfo of meter who created this log
@property (nonatomic, strong) OTInstrumentationLibraryInfo *instrumentationLibraryInfo;

/// time stamp when log record was created, deafult is zero and set by OpenTelemetrySDK, user can customize it if needed.
@property (nonatomic, assign) NSTimeInterval timeUnixNano;

/// 更新 severityNumber
- (void)updateSeverityNumber;

@end

NS_ASSUME_NONNULL_END
