//
//  OTLoggingExporter.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingExporter.h"
#import "OTDependencyDefine.h"
#ifdef OT_LOGGING_SDK_EXPORTER
#import "OTLoggingExporterImp.h"
#endif
#ifdef OT_PROTO_CONVERTER_LOG
#import "OTLoggingProtoExporterImp.h"
#endif

@interface OTLoggingExporter ()
@property (nonatomic, strong) id<OTLoggingExporterProtocol> impObject;
@end

@implementation OTLoggingExporter

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_PROTO_CONVERTER_LOG
        _impObject = [[OTLoggingProtoExporterImp alloc] init];
#else
#ifdef OT_LOGGING_SDK_EXPORTER
        _impObject = OTLoggingExporterImp.new;
#endif
#endif
    }
    return self;
}

#pragma mark - Getter & Setter
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

- (void)exportRecords:(NSArray<OTLoggingRecordData *> *)recordsData resource:(OTResource *)resource completion:(OTExporterCallback)completion {
    if ([self.impObject respondsToSelector:@selector(exportRecords:resource:completion:)]) {
        [self.impObject exportRecords:recordsData resource:resource completion:completion];
    } else {
        NSError *error = [NSError errorWithDomain:gOTExporterErrorDomain
                                             code:gOTExporterNotImplemented
                                         userInfo:@{ NSLocalizedDescriptionKey : @"OTExporter not implemented" }];
        if (completion) {
            completion(0, nil, error);
        }
    }
}

- (void)shutdown {
    [self.impObject shutdown];
}

@end
