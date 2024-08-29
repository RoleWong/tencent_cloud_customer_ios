//
//  OTMetricReaderProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricExporterProtocol.h"
#import "OTCallbackDefine.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"

@class OTInstrument, OTMetricDataPoint, OTMetricDataSink, OTMeter, OTResource;

#ifndef OTMetricReaderProtocol_h
#define OTMetricReaderProtocol_h

typedef OTSafeArray<OTMetricDataSink *> * (^OTMeterColletBlock)(void);

typedef void (^OTMetricReaderBlock)(void);

/// Metric reader responsible for creating meteric data points in a certain period, and collect metic data to exporter when  exporter is ready to
/// export
@protocol OTMetricReaderProtocol <NSObject>

@property (nonatomic, strong) OTResource *resource;

/// this block will called when metric exporter needs to export metric datas
@property (nonatomic, copy) OTMeterColletBlock collectCallback;

/// this block will cakked when a bunch of metric data were reported
@property (nonatomic, copy) OTExporterCallback onMetricReportedCallback;

/// this block will called when metric reader needs to create an new data point
@property (nonatomic, copy) OTMetricReaderBlock onMetricDataRead;

/// Exporter that responsible for exporting collected instruments
@property (nonatomic, strong) id<OTMetricExporterProtocol> exporter;

/// config the interval between metric data read, time value below zero will consider as an invalid parameter
@property (nonatomic, assign) NSTimeInterval readIntervalMillis;

/// shut down data collecting
- (void)shutdown;

/// upload all instuments data available
- (void)forceFlush;

@end

#endif /* OTMetricReaderProtocol_h */
