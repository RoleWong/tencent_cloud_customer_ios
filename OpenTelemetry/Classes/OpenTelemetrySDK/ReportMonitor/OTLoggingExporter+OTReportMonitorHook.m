//
//  OTLoggingExporter+OTReportMonitorHook.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingExporter+OTReportMonitorHook.h"
#import "OTReportMonitor.h"

@implementation OTLoggingExporter (OTReportMonitorHook)

- (void)monitoredExportRecords:(NSArray<OTLoggingRecord *> *)records
                      resource:(OTResource *)resource
                    completion:(OTExporterCallback)completion {
    [self monitoredExportRecords:records
                        resource:resource
                      completion:^(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error) {
                          NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                          [userInfo setValue:resource forKey:OpenTelemetryReportDataKeyResource];
                          BOOL success = statusCode == 200;
                          [userInfo setValue:@(success) forKey:OpenTelemetryReportDataKeyResult];
                          [[NSNotificationCenter defaultCenter] postNotificationName:OpenTelemetryLoggingHookNotification
                                                                              object:records
                                                                            userInfo:userInfo];
                          if (completion) {
                              completion(statusCode, dataString, error);
                          }
                      }];
}

@end
