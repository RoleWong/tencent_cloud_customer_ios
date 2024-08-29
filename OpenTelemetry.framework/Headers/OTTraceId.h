//
//  OTTraceId.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSUInteger const gTraceIdLength;

@interface OTTraceId : OTBaseObject

/// 十六进制字符串显示ID
@property (nonatomic, copy, readonly) NSString *hexString;

/// 判断Id是否有效
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// 根据HexString生成Id
/// @param hexString hex字符串
- (instancetype)initWithHexString:(NSString *)hexString;

/// 判断是否与另一个id相等
/// @param traceId 另一个TraceId
- (BOOL)isEqualToTraceId:(OTTraceId *)traceId;

@end

NS_ASSUME_NONNULL_END
