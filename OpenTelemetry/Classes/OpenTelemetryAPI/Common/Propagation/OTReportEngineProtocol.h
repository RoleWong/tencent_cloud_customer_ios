//
//  OTReportEngineProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef OTReportEngineProtocol_h
#define OTReportEngineProtocol_h

#import "OTCallbackDefine.h"
#import "OTDependencyDefine.h"
#import "OTCarrier.h"
#import "OTAbnormalNetworkDBManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTReportEngineProtocol <NSObject>

/// this method is called only by the OTMeticExporter
/// @param metricCarrier metric data carrier
/// @param extParam other params
- (void)reportMetircData:(OTCarrier *)metricCarrier
                extParam:(NSDictionary<NSString *, NSString *> *)extParam
              completion:(OTExporterCallback _Nullable)completion;

/// this method is called only by the OTLoggingExporter
/// @param logCarrier log data carrier
/// @param extParam other params, will transfer as request header
- (void)reportLogData:(OTCarrier *)logCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback _Nullable)completion;

/// this method is called only by the OTSpanExporter
/// @param tracingCarrier span data acrrier
/// @param extParam other params
- (void)reportTracingData:(OTCarrier *)tracingCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback _Nullable)completion;

@optional
/// this method is called only by the BusinessDelayReport
/// @param dataItem report needed data
/// @param completion callback
- (void)reportDataWith:(OTAbnormalNetworkDataItem *)dataItem
            completion:(void (^)(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData))completion;

@end

NS_ASSUME_NONNULL_END

#endif /* OTReportEngineProtocol_h */
