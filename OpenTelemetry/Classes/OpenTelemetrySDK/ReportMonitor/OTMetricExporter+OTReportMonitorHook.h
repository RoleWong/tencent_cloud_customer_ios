//
//  OTMetricExporter+OTReportMonitorHook.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMetricExporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMetricExporter (OTReportMonitorHook)

/// Hooked method for metric export
/// @param batchedMetricData metric data
/// @param resource resource
/// @param completion completion
- (void)monitoredExportBatching:(NSArray<OTMetricDataSink *> *)batchedMetricData
                       resource:(OTResource *)resource
                     completion:(OTExporterCallback)completion;

@end

NS_ASSUME_NONNULL_END
