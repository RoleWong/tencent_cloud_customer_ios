//
//  OTLoggingJsonConverter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTResource.h"
#import "OTLoggingRecordData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingJsonConverter : NSObject

/// Convert Logging records and resource into json format
/// @param recordsData logging records
/// @param resource resource
+ (NSDictionary *)resourceLogsDataFromRecords:(NSArray<OTLoggingRecordData *> *)recordsData resource:(OTResource *)resource;

@end

NS_ASSUME_NONNULL_END
