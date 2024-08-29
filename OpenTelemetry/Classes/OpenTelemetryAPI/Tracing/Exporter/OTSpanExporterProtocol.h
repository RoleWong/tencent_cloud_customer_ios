//
//  OTSpanExporterProtocol.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTCallbackDefine.h"
#import "OTReportEngineProtocol.h"
#import "OTSpanData.h"
#import "OTResource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTSpanExporterProtocol <NSObject>

/// instance that responsible for reporting span data
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

/// config the header of the teelemetry data report request
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

/// processor call this method to export span data
/// @param spansData spansData to export
/// @param resource resource
/// @param completion completion callback
- (void)exportSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource completion:(OTExporterCallback)completion;

/// 关闭导出器, 被关闭的导出器不再导出数据
- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
