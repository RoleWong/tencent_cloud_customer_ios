//
//  OTLoggingExporterProtocol.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTReportEngineProtocol.h"
#import "OTCallbackDefine.h"
#import "OTLoggingRecordData.h"

@class OTLoggingRecord, OTResource, OTInstrumentationLibraryInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol OTLoggingExporterProtocol <NSObject>

/// delegate that handle metric  data upload via network
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

/// config the header of the teelemetry data report request
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

/// processor call this method to export log data
/// @param recordsData log records data
/// @param resource resource
/// @param completion completion callback
- (void)exportRecords:(NSArray<OTLoggingRecordData *> *)recordsData resource:(OTResource *)resource completion:(OTExporterCallback)completion;

- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
