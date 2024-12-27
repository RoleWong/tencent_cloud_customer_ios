//
//  OTCallbackHelper.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/9/10.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTCallbackDefine.h"

@class OTSpan;

typedef void (^OTReportResultBlock)(NSString *_Nonnull requestJsonString, NSInteger statusCode, BOOL success, NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const gOTExportTracingApi;
FOUNDATION_EXPORT NSString *const gOTExportMetricApi;
FOUNDATION_EXPORT NSString *const gOTExportLoggingApi;

FOUNDATION_EXPORT NSNotificationName const gOTReportResponseInfoKeyJsonString;
FOUNDATION_EXPORT NSNotificationName const gOTReportResponseInfoKeyStatusCode;
FOUNDATION_EXPORT NSNotificationName const gOTReportResponseInfoKeyResult;
FOUNDATION_EXPORT NSNotificationName const gOTReportResponseInfoKeyError;
FOUNDATION_EXPORT NSNotificationName const gOTReportResponseInfoKeyApi;

FOUNDATION_EXPORT NSNotificationName const gOTSampleResultInfoKeyName;
FOUNDATION_EXPORT NSNotificationName const gOTSampleResultInfoKeyResult;

FOUNDATION_EXPORT NSNotificationName const gOTDataReportDidResponseNotification;

/// This is a tool in helping you get callback infomation in the whole telemetry process, IT CAN ONLY BE USED IN DEBUG CIRCUMSTANCE, DO NOT IMPLEMENT
/// BUSSINESS LOGINC WITH IT.
@interface OTCallbackHelper : NSObject

/// this callback was called when a span batch is exported and get a response;
@property (nonatomic, copy)
    OTReportResultBlock spanReportResultHandler __deprecated_msg("deprecated, use OTSpanProcessorProtocol.onSpanReportedCallback instead");

/// this callback was called when a metric batch is exported and get a response;
@property (nonatomic, copy)
    OTReportResultBlock metricReportResultHandler __deprecated_msg("deprecated, use OTMetricReaderProtocol.onMetricReportedCallback instead");

/// this callback was called when a log batch is exported and get a response;
@property (nonatomic, copy)
    OTReportResultBlock loggingReportResultHandler __deprecated_msg("deprecated, use OTLoggingProcessorProtocol.onLogReportedCallback instead");

+ (instancetype)defaultHelper;

@end

NS_ASSUME_NONNULL_END
