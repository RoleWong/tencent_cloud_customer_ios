//
//  OTSpanId.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSUInteger const gSpanIdLength;

@interface OTSpanId : OTBaseObject

/// 十六进制字符串显示ID
@property (nonatomic, copy, readonly) NSString *hexString;

/// 判断ID是否有效
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// 根据Hex字符串生成指定Id
/// @param hexString Hex字符串
- (instancetype)initWithHexString:(NSString *)hexString;

/// 判断是否和另一个Id相等
/// @param spanId 另一个SpanId
- (BOOL)isEqualToSpanId:(OTSpanId *)spanId;

@end

NS_ASSUME_NONNULL_END
