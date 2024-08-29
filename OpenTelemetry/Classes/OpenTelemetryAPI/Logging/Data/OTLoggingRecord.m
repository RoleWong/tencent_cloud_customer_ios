//
//  OTLoggingRecord.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/17.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingRecord.h"
#import "OTResource.h"
#import "OTClock.h"
#import "OTLoggingKeyValue.h"
#import "OTLoggingAnyValue.h"
#import "OTLoggingRecord+Private.h"

@interface OTLoggingRecord ()
/// 默认的 log 值与 android 不对齐，需更新对齐key
@property (nonatomic, assign) BOOL needUpdateSeverityNumber;

@end

@implementation OTLoggingRecord

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionary];
    NSTimeInterval time = self.timeUnixNano;
    if (time == 0) {
        time = self.clock.nanoSecondTime;
    }
    NSString *unixTimeNano = [NSString stringWithFormat:@"%lld", (uint64_t)time];
    [jsonData setValue:unixTimeNano forKey:OTLoggingRecordKey_timestamp];
    [jsonData setValue:self.traceId forKey:OTLoggingRecordKey_traceId];
    [jsonData setValue:self.spanId forKey:OTLoggingRecordKey_spanId];
    [jsonData setValue:self.name forKey:OTLoggingRecordKey_name];
    [jsonData setValue:@(self.traceFlags) forKey:OTLoggingRecordKey_traceFlags];
    [jsonData setValue:self.getSeverityText forKey:OTLoggingRecordKey_severityText];
    [jsonData setValue:@(self.severity) forKey:OTLoggingRecordKey_severity];
    [jsonData setValue:[self attributesJson] forKey:OTLoggingRecordKey_attributes];
    [jsonData setValue:[self.body toJson] forKey:OTLoggingRecordKey_body];

    if (self.needUpdateSeverityNumber) {
        [jsonData setValue:[self obtainSeverityNumberText] forKey:OTLoggingRecordKey_severity];
    }
    
    return jsonData;
}

- (NSArray *)attributesJson {
    NSMutableArray *attributes = [NSMutableArray array];
    for (OTAttribute *sampleAttribute in self.attributes) {
        NSDictionary *attributeJson = sampleAttribute.toJson;
        if (attributeJson) {
            [attributes addObject:attributeJson];
        }
    }
    return [NSArray arrayWithArray:attributes];
}

- (NSString *)getSeverityText {
    if (self.severityText.length) {
        return self.severityText;
    }

    NSDictionary *severityTextMap = @{
        @(OTLoggingRecordSeverityUndefined) : @"Undefined",
        @(OTLoggingRecordSeverityTrace) : @"Trace",
        @(OTLoggingRecordSeverityTrace2) : @"Trace2",
        @(OTLoggingRecordSeverityTrace3) : @"Trace3",
        @(OTLoggingRecordSeverityTrace4) : @"Trace4",
        @(OTLoggingRecordSeverityDebug) : @"Debug",
        @(OTLoggingRecordSeverityDebug2) : @"Debug2",
        @(OTLoggingRecordSeverityDebug3) : @"Debug3",
        @(OTLoggingRecordSeverityDebug4) : @"Debug4",
        @(OTLoggingRecordSeverityInfo) : @"Info",
        @(OTLoggingRecordSeverityInfo2) : @"Info2",
        @(OTLoggingRecordSeverityInfo3) : @"Info3",
        @(OTLoggingRecordSeverityInfo4) : @"Info4",
        @(OTLoggingRecordSeverityWarn) : @"Warn",
        @(OTLoggingRecordSeverityWarn2) : @"Warn2",
        @(OTLoggingRecordSeverityWarn3) : @"Warn3",
        @(OTLoggingRecordSeverityWarn4) : @"Warn4",
        @(OTLoggingRecordSeverityError) : @"Error",
        @(OTLoggingRecordSeverityError2) : @"Error2",
        @(OTLoggingRecordSeverityError3) : @"Error3",
        @(OTLoggingRecordSeverityError4) : @"Error4",
        @(OTLoggingRecordSeverityFatal) : @"Fatal",
        @(OTLoggingRecordSeverityFatal2) : @"Fatal2",
        @(OTLoggingRecordSeverityFatal3) : @"Fatal3",
        @(OTLoggingRecordSeverityFatal4) : @"Fatal4"
    };
    return severityTextMap[@(self.severity)];
}

/// 与android对齐severityNumber字段值
- (NSString *)obtainSeverityNumberText {
    static NSDictionary *severityNumberTextMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        severityNumberTextMap =  @{
            @(OTLoggingRecordSeverityUndefined) : @"SEVERITY_NUMBER_UNDEFINED",
            @(OTLoggingRecordSeverityTrace)     : @"SEVERITY_NUMBER_TRACE",
            @(OTLoggingRecordSeverityTrace2)    : @"SEVERITY_NUMBER_TRACE2",
            @(OTLoggingRecordSeverityTrace3)    : @"SEVERITY_NUMBER_TRACE3",
            @(OTLoggingRecordSeverityTrace4)    : @"SEVERITY_NUMBER_TRACE4",
            @(OTLoggingRecordSeverityDebug)     : @"SEVERITY_NUMBER_DEBUG",
            @(OTLoggingRecordSeverityDebug2)    : @"SEVERITY_NUMBER_DEBUG2",
            @(OTLoggingRecordSeverityDebug3)    : @"SEVERITY_NUMBER_DEBUG3",
            @(OTLoggingRecordSeverityDebug4)    : @"SEVERITY_NUMBER_DEBUG4",
            @(OTLoggingRecordSeverityInfo)      : @"SEVERITY_NUMBER_INFO",
            @(OTLoggingRecordSeverityInfo2)     : @"SEVERITY_NUMBER_INFO2",
            @(OTLoggingRecordSeverityInfo3)     : @"SEVERITY_NUMBER_INFO3",
            @(OTLoggingRecordSeverityInfo4)     : @"SEVERITY_NUMBER_INFO4",
            @(OTLoggingRecordSeverityWarn)      : @"SEVERITY_NUMBER_WARN",
            @(OTLoggingRecordSeverityWarn2)     : @"SEVERITY_NUMBER_WARN2",
            @(OTLoggingRecordSeverityWarn3)     : @"SEVERITY_NUMBER_WARN3",
            @(OTLoggingRecordSeverityWarn4)     : @"SEVERITY_NUMBER_WARN4",
            @(OTLoggingRecordSeverityError)     : @"SEVERITY_NUMBER_ERROR",
            @(OTLoggingRecordSeverityError2)    : @"SEVERITY_NUMBER_ERROR2",
            @(OTLoggingRecordSeverityError3)    : @"SEVERITY_NUMBER_ERROR3",
            @(OTLoggingRecordSeverityError4)    : @"SEVERITY_NUMBER_ERROR4",
            @(OTLoggingRecordSeverityFatal)     : @"SEVERITY_NUMBER_FATAL",
            @(OTLoggingRecordSeverityFatal2)    : @"SEVERITY_NUMBER_FATAL2",
            @(OTLoggingRecordSeverityFatal3)    : @"SEVERITY_NUMBER_FATAL3",
            @(OTLoggingRecordSeverityFatal4)    : @"SEVERITY_NUMBER_FATAL4"
        };
    });

    NSString *undefineResult = severityNumberTextMap[@(OTLoggingRecordSeverityUndefined)];
    NSString *result = severityNumberTextMap[@(self.severity)];
    if (!result) {
        return undefineResult;
    }
    return result;
}

- (void)updateSeverityNumber {
    self.needUpdateSeverityNumber = YES;
}

@end
