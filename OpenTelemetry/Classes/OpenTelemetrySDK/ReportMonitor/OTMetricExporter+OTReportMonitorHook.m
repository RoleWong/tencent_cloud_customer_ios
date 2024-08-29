//
//  OTMetricExporter+OTReportMonitorHook.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMetricExporter+OTReportMonitorHook.h"
#import "OTReportMonitor.h"

@implementation OTMetricExporter (OTReportMonitorHook)

- (void)monitoredExportBatching:(NSArray<OTMetricDataSink *> *)batchedMetricData
                       resource:(OTResource *)resource
                     completion:(OTExporterCallback)completion {
    [self monitoredExportBatching:batchedMetricData
                         resource:resource
                       completion:^(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error) {
                           NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                           [userInfo setValue:resource forKey:OpenTelemetryReportDataKeyResource];
                           BOOL success = statusCode == 200;
                           [userInfo setValue:@(success) forKey:OpenTelemetryReportDataKeyResult];
                           [[NSNotificationCenter defaultCenter] postNotificationName:OpenTelemetryMetricHookNotification
                                                                               object:batchedMetricData
                                                                             userInfo:userInfo];
                           if (completion) {
                               completion(statusCode, dataString, error);
                           }
                       }];
}

@end
