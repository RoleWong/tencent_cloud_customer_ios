//
//  OTLoggingExporter+OTReportMonitorHook.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingExporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingExporter (OTReportMonitorHook)

/// hooked method for log export
/// @param records log records to export
/// @param resource resource
/// @param completion completion
- (void)monitoredExportRecords:(NSArray<OTLoggingRecord *> *)records
                      resource:(OTResource *)resource
                    completion:(OTExporterCallback)completion;

@end

NS_ASSUME_NONNULL_END

