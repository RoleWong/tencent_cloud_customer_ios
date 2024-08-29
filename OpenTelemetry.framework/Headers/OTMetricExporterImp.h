//
//  OTMetricExporterImp.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMetricExporterProtocol.h"
#import "OTReportEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMetricExporterImp : NSObject <OTMetricExporterProtocol>

/// type of the exporter
@property (nonatomic, assign) OTMetricExporterMode mode;

/// export intervals betweet two exportation, useless when exporter is pull exporter type
@property (nonatomic, assign) NSTimeInterval exportTimeIntervalMills;

/// callback to inform the metric reader that pass metric data to exporter
@property (nonatomic, copy) OTMetricExporterNeedCollectHandler needCollectMetricCallback;

/// the delgate object responseble for sending metric data to backend
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

/// config the header of the teelemetry data report request
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

@end

NS_ASSUME_NONNULL_END
