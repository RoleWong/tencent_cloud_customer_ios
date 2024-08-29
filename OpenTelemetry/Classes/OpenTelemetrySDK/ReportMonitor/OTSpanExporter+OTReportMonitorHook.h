//
//  OTSpanExporter+OTReportMonitorHook.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTSpanExporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSpanExporter (OTReportMonitorHook)

/// hooked method for trace export
/// @param spansData spansData to export
/// @param resource resource
/// @param completion completion
- (void)monitoredExportSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource completion:(OTExporterCallback)completion;

@end

NS_ASSUME_NONNULL_END
