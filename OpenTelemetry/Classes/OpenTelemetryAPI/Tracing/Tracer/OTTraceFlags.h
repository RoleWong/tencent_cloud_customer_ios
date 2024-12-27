//
//  OTTraceFlags.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTTraceFlags : OTBaseObject

@property (nonatomic, copy, readonly) NSString *hexString;

/// 是否需要染色
@property (nonatomic, assign, getter=isSampled) BOOL sampled;

- (instancetype)initWithByte:(UInt8)byte;

- (instancetype)settingSampled:(BOOL)sampled;

/// 判定是否和另一个TraceFlag相等
/// @param traceFlag 另一个踪迹配置
- (BOOL)isEqualToTraceFlag:(OTTraceFlags *)traceFlag;

@end

NS_ASSUME_NONNULL_END
