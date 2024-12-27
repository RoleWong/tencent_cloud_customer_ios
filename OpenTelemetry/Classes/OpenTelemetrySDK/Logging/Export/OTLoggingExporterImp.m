//
//  OTLoggingExporterImp.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingExporterImp.h"
#import "OTDependencyDefine.h"
#import "OTLoggingRecord.h"
#import "OTResource.h"
#import "OTReportEngine.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTInstrumentationLibraryExportUnit.h"
#import "OTLogDataReportKeys.h"
#import "OTLoggingJsonConverter.h"
#import "OTCarrier.h"

@interface OTLoggingExporterImp ()
@property (nonatomic, assign) BOOL isShutdown;
@end

@implementation OTLoggingExporterImp

- (instancetype)init {
    if (self = [super init]) {
        _isShutdown = NO;
    }
    return self;
}

- (id<OTReportEngineProtocol>)delegate {
    if (!_delegate) {
        _delegate = [[OTReportEngine alloc] init];
    }
    return _delegate;
}

- (void)exportRecords:(NSArray<OTLoggingRecordData *> *)recordsData resource:(OTResource *)resource completion:(OTExporterCallback)completion {
    if (self.isShutdown) {
        NSError *shutdownError = [NSError errorWithDomain:gOTExporterErrorDomain
                                                     code:gOTExporterShuttedDown
                                                 userInfo:@{ NSLocalizedDescriptionKey : @"exporter shutted down" }];
        completion(0, nil, shutdownError);
        return;
    }
    if (recordsData.count == 0) {
        completion(0, nil, nil);
        return;
    }
    if (![self.delegate respondsToSelector:@selector(reportLogData:extParam:completion:)]) {
        NSError *notImplentedError = [NSError errorWithDomain:gOTExporterErrorDomain
                                                         code:gOTExporterNotReportEngine
                                                     userInfo:@{ NSLocalizedDescriptionKey : @"Report engine not implemented reportLogData" }];
        completion(0, nil, notImplentedError);
        return;
    }
    NSDictionary *parameter = [OTLoggingJsonConverter resourceLogsDataFromRecords:recordsData resource:resource];
    NSError *jsonError = nil;
    OTCarrier *jsonCarrier = [OTCarrier carrierWithJsonObject:parameter error:&jsonError];
    if (jsonError) {
        completion(0, nil, jsonError);
    } else {
        [self.delegate reportLogData:jsonCarrier extParam:self.headerForRequest completion:completion];
    }
}

- (void)shutdown {
    if (self.isShutdown) {
        return;
    }
    self.isShutdown = YES;
}

@end
