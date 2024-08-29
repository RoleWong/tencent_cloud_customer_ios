//
//  OTReportMonitor.m
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <objc/runtime.h>
#import "OTReportMonitor.h"
#import "OTMetric.h"
#import "OTLoggingExporter.h"
#import "OTSpanExporter+OTReportMonitorHook.h"
#import "OTMetricExporter+OTReportMonitorHook.h"
#import "OTLoggingExporter+OTReportMonitorHook.h"
#import "OTCallbackHelper.h"
#import "OTReportEngine.h"

static NSString *const gOTReportMonitorActionType = @"opentelemetry_report_monoitor";
static NSString *const gOTReportMonitorActionTypeKey = @"opentelemetry_action_type";

NSNotificationName const OpenTelemetryLoggingHookNotification = @"OpenTelemetryLoggingHookNotification";
NSNotificationName const OpenTelemetryMetricHookNotification = @"OpenTelemetryMetricHookNotification";
NSNotificationName const OpenTelemetrySpanHookNotification = @"OpenTelemetrySpanHookNotification";

NSString *const OpenTelemetryReportDataKeyResource = @"OpenTelemetryReportDataKeyResource";
NSString *const OpenTelemetryReportDataKeyResult = @"OpenTelemetryReportDataKeyResult";

@interface OTReportMonitor ()

@property (nonatomic, strong) OTMeterProvider *meterProvider;
@property (nonatomic, strong) OTMeter *meter;
@property (nonatomic, strong) OTCounter *reportCounter;

@end

@implementation OTReportMonitor

BOOL ot_exchange_method(Class objClass, SEL originSelector, SEL newSelector) {
    Method originMethod = class_getInstanceMethod(objClass, originSelector);
    Method newMethod = class_getInstanceMethod(objClass, newSelector);

    if (originMethod && newMethod) {
        method_exchangeImplementations(originMethod, newMethod);
        return YES;
    }
    return NO;
}

- (instancetype)init {
    if (self = [super init]) {
        OTResource *resouce = [OTResource resourceWithDictionary:@{ gOTReportMonitorActionTypeKey : gOTReportMonitorActionType }];
        _meterProvider = [[OTMeterProvider alloc] initWithResource:resouce];
        _meter = [self.meterProvider meterWithName:@"OPENTELEMETERY_SELF_MONITOR" version:@"1.0.1" schemaUrl:nil];
        _reportCounter = [self.meter createCounter:@"tpstelemetry_sdk_batch_process_counter" unit:@"Time" description:@"Record the report results"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(monitorDidReceviceReportResultNotification:)
                                                     name:OpenTelemetrySpanHookNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(monitorDidReceviceReportResultNotification:)
                                                     name:OpenTelemetryMetricHookNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(monitorDidReceviceReportResultNotification:)
                                                     name:OpenTelemetryLoggingHookNotification
                                                   object:nil];
    }
    return self;
}

+ (instancetype)defaultMonitor {
    static dispatch_once_t onceToken;
    static OTReportMonitor *helperInstance = nil;
    dispatch_once(&onceToken, ^{
        helperInstance = [[OTReportMonitor alloc] init];
    });
    return helperInstance;
}

#pragma mark - Public

- (void)shutdown {
    [self.meterProvider shutdown];
}

- (void)hookExportResultsToDomainName:(NSString *)domainName {
    OTReportEngine *reportEngine = self.meterProvider.defaultMetricReader.exporter.delegate;
    reportEngine.reportDestinationDomainName = domainName;
    ot_exchange_method([OTMetricExporter class], @selector(exportBatching:resource:completion:),
                       @selector(monitoredExportBatching:resource:completion:));
    ot_exchange_method([OTSpanExporter class], @selector(exportSpansData:resource:completion:),
                       @selector(monitoredExportSpansData:resource:completion:));
    ot_exchange_method([OTLoggingExporter class], @selector(exportRecords:resource:completion:),
                       @selector(monitoredExportRecords:resource:completion:));
}

#pragma mark - Notification

- (NSString *)telemetryFromNotificationName:(NSString *)notificationName {
    NSString *telemetry = @"";
    if ([notificationName isEqualToString:OpenTelemetrySpanHookNotification]) {
        telemetry = @"traces";
    } else if ([notificationName isEqualToString:OpenTelemetryMetricHookNotification]) {
        telemetry = @"metrics";
    } else if ([notificationName isEqualToString:OpenTelemetryLoggingHookNotification]) {
        telemetry = @"logs";
    }
    return telemetry;
}

- (void)monitorDidReceviceReportResultNotification:(NSNotification *)notification {
    OTResource *resource = [notification.userInfo objectForKey:OpenTelemetryReportDataKeyResource];
    NSNumber *result = [notification.userInfo objectForKey:OpenTelemetryReportDataKeyResult];
    NSString *resultString = result.boolValue ? @"success" : @"failed";
    NSString *actionType = [resource stringValueForKey:gOTReportMonitorActionTypeKey];
    // avoid self call loop
    if ([actionType isEqualToString:gOTReportMonitorActionType]) {
        return;
    }
    self.meterProvider.resource = [self.meterProvider.resource mergeWithResource:resource];
    [self.reportCounter add:1 attibutes:@{ @"status" : resultString, @"telemetry" : [self telemetryFromNotificationName:notification.name] }];
}

@end
