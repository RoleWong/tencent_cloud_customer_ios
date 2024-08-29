//
//  OTMetricExporter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMetricExporter.h"

#import "OTDependencyDefine.h"
#import "OTCallbackDefine.h"
#import "OTDependencyDefine.h"
#ifdef OT_METRIC_SDK_EXPORTER
#import "OTMetricExporterImp.h"
#endif
#ifdef OT_PROTO_CONVERTER_METRIC
#import "OTMetricProtoExporterImp.h"
#endif

@interface OTMetricExporter ()

@property (nonatomic, strong) id<OTMetricExporterProtocol> impObject;

@end

@implementation OTMetricExporter

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_PROTO_CONVERTER_METRIC
        _impObject = [[OTMetricProtoExporterImp alloc] init];
#else
#ifdef OT_METRIC_SDK_EXPORTER
        _impObject = [[OTMetricExporterImp alloc] init];
#endif
#endif
    }
    return self;
}

#pragma mark - Getter & Setter

- (OTMetricExporterMode)mode {
    return self.impObject.mode;
}

- (id<OTReportEngineProtocol>)delegate {
    return self.impObject.delegate;
}

- (void)setDelegate:(id<OTReportEngineProtocol>)delegate {
    self.impObject.delegate = delegate;
}

- (NSDictionary<NSString *, NSString *> *)headerForRequest {
    return self.impObject.headerForRequest;
}

- (void)setHeaderForRequest:(NSDictionary<NSString *, NSString *> *)headerForRequest {
    self.impObject.headerForRequest = headerForRequest;
}

- (void)setMode:(OTMetricExporterMode)type {
    self.impObject.mode = type;
}

- (NSTimeInterval)exportTimeIntervalMills {
    return [self.impObject exportTimeIntervalMills];
}

- (void)setExportTimeIntervalMills:(NSTimeInterval)exportTimeIntervalMills {
    [self.impObject setMode:exportTimeIntervalMills];
}

- (OTMetricExporterNeedCollectHandler)needCollectMetricCallback {
    return self.impObject.needCollectMetricCallback;
}

- (void)setNeedCollectMetricCallback:(OTMetricExporterNeedCollectHandler)needCollectMetricCallback {
    self.impObject.needCollectMetricCallback = needCollectMetricCallback;
}

#pragma mark - Public

- (void)exportBatching:(OTSafeArray<OTMetricDataSink *> *)batchedMetricData
              resource:(OTResource *)resource
            completion:(OTExporterCallback)completion {
    if ([self.impObject respondsToSelector:@selector(exportBatching:resource:completion:)]) {
        [self.impObject exportBatching:batchedMetricData resource:resource completion:completion];
    } else {
        NSError *error = [NSError errorWithDomain:gOTExporterErrorDomain
                                             code:gOTExporterNotImplemented
                                         userInfo:@{ NSLocalizedDescriptionKey : @"Metric exporter not implemented" }];
        if (completion) {
            completion(0, nil, error);
        }
    }
}

- (void)forceFlush {
    [self.impObject forceFlush];
}

- (void)shutdown {
    [self.impObject shutdown];
}

- (void)exportMetricData {
    [self.impObject exportMetricData];
}

@end
