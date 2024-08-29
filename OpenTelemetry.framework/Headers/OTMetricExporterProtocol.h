//
//  OTMetricExporterProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef OTMetricExporterProtocol_h
#define OTMetricExporterProtocol_h

#import "OTCallbackDefine.h"
#import "OTReportEngineProtocol.h"
#import "OTSafeArray.h"

@class OTMetricDataSink, OTResource;

typedef NS_ENUM(NSUInteger, OTMetricExporterMode) {
    OTMetricExporterModePush, // export metric data on it's stand alone schedule, default mode
    OTMetricExporterModePull, // export metric data immediately if exporter receive metric data from reader
};

typedef void (^OTMetricExporterNeedCollectHandler)(void);

@protocol OTMetricExporterProtocol <NSObject>

/// type of the exporter
@property (nonatomic, assign) OTMetricExporterMode mode;

/// export intervals betweet two exportation, useless when exporter is pull exporter type
@property (nonatomic, assign) NSTimeInterval exportTimeIntervalMills;

/// callback to inform the metric reader that pass metric data to exporter
@property (nonatomic, copy) OTMetricExporterNeedCollectHandler needCollectMetricCallback;

/// delegate that handle metric  data upload via network
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

/// config the header of the teelemetry data report request
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

/// export metric data to backend
/// @param batchedMetricData metric data to be exported
/// @param resource common resource from meter provider
/// @param completion callback
- (void)exportBatching:(OTSafeArray<OTMetricDataSink *> *)batchedMetricData resource:(OTResource *)resource completion:(OTExporterCallback)completion;

/// export all metric data stashed in eporter, useless for pull exporter type
- (void)forceFlush;

/// stop all export action for this exporter
- (void)shutdown;

/// exportReaderCollectedMetricData, only available in pull exporter mode
- (void)exportMetricData;

@end

#endif /* OTMetricExporterProtocol_h */
