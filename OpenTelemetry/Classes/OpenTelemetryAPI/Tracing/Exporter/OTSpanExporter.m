//
//  OTSpanExporter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/24.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanExporter.h"
#import "OTSpan.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_EXPORTER
#import "OTSpanExporterImp.h"
#endif
#ifdef OT_PROTO_CONVERTER_TRACE
#import "OTSpanProtoExporterImp.h"
#endif

@interface OTSpanExporter()
@property (nonatomic, strong) id<OTSpanExporterProtocol> impObject;
@end

@implementation OTSpanExporter

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_PROTO_CONVERTER_TRACE
        _impObject = [[OTSpanProtoExporterImp alloc] init];
#else
#ifdef OT_TRACING_SDK_EXPORTER
        _impObject = [[OTSpanExporterImp alloc] init];
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

- (void)exportSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource completion:(OTExporterCallback)completion {
    if ([self.impObject respondsToSelector:@selector(exportSpansData:resource:completion:)]) {
        [self.impObject exportSpansData:spansData resource:resource completion:completion];
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
