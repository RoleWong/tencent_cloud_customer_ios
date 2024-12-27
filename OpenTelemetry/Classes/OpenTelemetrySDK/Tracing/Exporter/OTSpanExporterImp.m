//
//  OTSpanExporterImp.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/24.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanExporterImp.h"
#import "OTDependencyDefine.h"
#import "OTSpan.h"
#import "OTTraceId.h"
#import "OTSpanId.h"
#import "OTTraceFlags.h"
#import "OTResource.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTInstrumentationLibraryExportUnit.h"
#import "OTReportEngine.h"
#import "OTSpanDataReportKeys.h"
#import "OTTraceJsonConverter.h"
#import "OTCarrier.h"

@interface OTSpanExporterImp ()

@property (nonatomic, assign, getter=isShuttedDown) BOOL shuttedDown;
@property (nonatomic, assign) NSInteger queueCapacity;

@end

@implementation OTSpanExporterImp

- (instancetype)init {
    if (self = [super init]) {
        _shuttedDown = NO;
    }
    return self;
}

#pragma mark - Getter & Setter

- (id<OTReportEngineProtocol>)delegate {
    if (!_delegate) {
        _delegate = [[OTReportEngine alloc] init];
    }
    return _delegate;
}

#pragma mark - OTSpanExporterProtocol

- (void)exportSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource completion:(OTExporterCallback)completion {
    if (self.isShuttedDown) {
        NSError *shutdownError = [NSError errorWithDomain:gOTExporterErrorDomain
                                                     code:gOTExporterShuttedDown
                                                 userInfo:@{ NSLocalizedDescriptionKey : @"exported shutted down" }];
        completion(0, nil, shutdownError);
        return;
    }
    if (spansData.count == 0) {
        completion(0, nil, nil);
        return;
    }
    // report engine reports the data to collector
    if (![self.delegate respondsToSelector:@selector(reportTracingData:extParam:completion:)]) {
        NSError *notImplentedError =
            [NSError errorWithDomain:gOTExporterErrorDomain
                                code:gOTExporterNotReportEngine
                            userInfo:@{ NSLocalizedDescriptionKey : @"Report engine not implemented for method reportTracingData" }];
        completion(0, nil, notImplentedError);
        return;
    }
    NSDictionary *parameter = [OTTraceJsonConverter traceDataWithSpansData:spansData resource:resource];
    NSError *jsonError = nil;
    OTCarrier *jsonCarrier = [OTCarrier carrierWithJsonObject:parameter error:&jsonError];
    if (jsonError) {
        completion(0, nil, jsonError);
    } else {
        [self.delegate reportTracingData:jsonCarrier extParam:self.headerForRequest completion:completion];
    }
}

- (void)shutdown {
    if (self.isShuttedDown) {
        return;
    }
    self.shuttedDown = YES;
}

@end
