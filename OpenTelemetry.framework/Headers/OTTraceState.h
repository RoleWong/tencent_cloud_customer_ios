//
//  OTTraceState.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTTraceState : OTBaseObject

/// 以Get请求参数的形式格式化traceState
@property (nonatomic, copy, readonly) NSString *serializationString;

/// 初始化踪迹状态
/// @param attributes 特征键值对数组
- (instancetype)initWithAttributes:(NSArray<OTAttribute *> *)attributes;

/// 根据序列化字符串构造踪迹状态
/// @param traceStateSerialization 序列化的踪迹字符串
- (nullable instancetype)initWithSerialization:(NSString *)traceStateSerialization;

/// 更新键值对
/// @param value 值
/// @param key 键
- (void)updateValue:(NSString *)value key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
