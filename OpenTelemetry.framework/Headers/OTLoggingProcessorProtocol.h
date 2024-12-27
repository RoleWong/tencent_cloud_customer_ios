//
//  OTLoggingProcessorProtocol.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTCallbackDefine.h"
#import "OTLoggingExporterProtocol.h"
#import "OTLoggingRecord.h"
#import "OTResource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTLoggingProcessorProtocol <NSObject>

@property (nonatomic, strong) OTResource *resource;

/// This block will called when a batch of logs were reported
@property (nonatomic, copy) OTExporterCallback onLogReportedCallback;

/// exporter for log exporting
@property (nonatomic, strong) id<OTLoggingExporterProtocol> exporter;

/// maximum number of logs that the processor can handle in a single row logs more than this limit will be ignored
@property (nonatomic, assign) NSUInteger maxQueueSize;

/// the time inteerval for each log records exportation
@property (nonatomic, assign) NSTimeInterval processInterval;

/// the maximum number of log records for each exportation
@property (nonatomic, assign) NSUInteger maxExportBatchSize;

@optional

/**
 * @brief 增加log记录
 * @param logRecord  记录Log信息的类
 */
- (void)addLogRecord:(OTLoggingRecord *)logRecord;

/**
 * @brief 关闭链接
 */
- (void)shutdown;

- (void)forceFlush;

@end

NS_ASSUME_NONNULL_END
