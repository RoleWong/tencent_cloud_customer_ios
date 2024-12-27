//
//  OTCallbackHelper.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/9/10.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTCallbackHelper.h"

NSErrorDomain const gOTExporterErrorDomain = @"OpenTelemetry.exporter.errorDomain";

NSInteger const gOTExporterNotImplemented = 10001;
NSInteger const gOTExporterShuttedDown = 10002;
NSInteger const gOTExporterNotReportEngine = 10003;
NSInteger const gOTExporterJsonFormatError = 10004;

NSNotificationName const gOTReportResponseInfoKeyJsonString = @"gOTReportResponseInfoKeyJsonString";
NSNotificationName const gOTReportResponseInfoKeyStatusCode = @"gOTReportResponseInfoKeyStatusCode";
NSNotificationName const gOTReportResponseInfoKeyResult = @"gOTReportResponseInfoKeyResult";
NSNotificationName const gOTReportResponseInfoKeyError = @"gOTReportResponseInfoKeyError";
NSNotificationName const gOTReportResponseInfoKeyApi = @"gOTReportResponseInfoKeyApi";

NSNotificationName const gOTSampleResultInfoKeyName = @"gOTSampleResultInfoKeyName";
NSNotificationName const gOTSampleResultInfoKeyResult = @"gOTSampleResultInfoKeyResult";
NSNotificationName const gOTSampleResultInfoKeyType = @"gOTSampleResultInfoKeyType";

NSNotificationName const gOTDataReportDidResponseNotification = @"gOTDataReportDidResponseNotification";
NSNotificationName const gOTSpanSampleResultNotification = @"gOTSpanSampleResultNotification";

NSString *const gOTExportTracingApi = @"v1/traces";
NSString *const gOTExportMetricApi = @"v1/metrics";
NSString *const gOTExportLoggingApi = @"v1/logs";

@implementation OTCallbackHelper

+ (instancetype)defaultHelper {
    static dispatch_once_t onceToken;
    static OTCallbackHelper *helperInstance = nil;
    dispatch_once(&onceToken, ^{
        helperInstance = [[OTCallbackHelper alloc] init];
    });
    return helperInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onReceiveDataReportNotification:)
                                                     name:gOTDataReportDidResponseNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Notificaiton

- (void)onReceiveDataReportNotification:(NSNotification *)notificaiton {
    NSString *jsonString = [notificaiton.userInfo objectForKey:gOTReportResponseInfoKeyJsonString];
    NSError *error = [notificaiton.userInfo objectForKey:gOTReportResponseInfoKeyError];
    NSNumber *result = [notificaiton.userInfo objectForKey:gOTReportResponseInfoKeyResult];
    NSNumber *statusCode = [notificaiton.userInfo objectForKey:gOTReportResponseInfoKeyStatusCode];

    NSString *api = [notificaiton.userInfo objectForKey:gOTReportResponseInfoKeyApi];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([api isEqualToString:gOTExportTracingApi] && self.spanReportResultHandler) {
        self.spanReportResultHandler(jsonString, statusCode.unsignedIntegerValue, result.boolValue, error);
    } else if ([api isEqualToString:gOTExportMetricApi] && self.metricReportResultHandler) {
        self.metricReportResultHandler(jsonString, statusCode.unsignedIntegerValue, result.boolValue, error);
    } else if ([api isEqualToString:gOTExportLoggingApi] && self.loggingReportResultHandler) {
        self.loggingReportResultHandler(jsonString, statusCode.unsignedIntegerValue, result.boolValue, error);
    }
#pragma clang diagnostic pop
}

@end
