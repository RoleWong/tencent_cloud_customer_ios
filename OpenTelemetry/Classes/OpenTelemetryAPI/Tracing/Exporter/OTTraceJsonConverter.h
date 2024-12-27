//
//  OTTraceJsonConverter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpanData.h"
#import "OTResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTTraceJsonConverter : NSObject

/// construcnt tracing data in json format
/// @param spansData spans data collected by processor
/// @param resource resouce of the tracer provider
+ (NSDictionary *)traceDataWithSpansData:(NSArray<OTSpanData *> *)spansData resource:(OTResource *)resource;

@end

NS_ASSUME_NONNULL_END
