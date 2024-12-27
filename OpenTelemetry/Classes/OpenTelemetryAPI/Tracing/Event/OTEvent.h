//
//  OTEvent.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"
#import "OTJsonConvertible.h"

NS_ASSUME_NONNULL_BEGIN

/// Event属于不可变对象, 因此初始化后不可以y修改其属性
@interface OTEvent : OTBaseObject <OTJsonConvertible>

/// 事件名称
@property (nonatomic, copy, readonly) NSString *name;

/// 被抛弃的Attribute个数
@property (nonatomic, assign, readonly) NSInteger droppedCount;

/// 事件特征
@property (nonatomic, strong, readonly) NSArray<OTAttribute *> *attributes;

/// 时间戳
@property (nonatomic, assign, readonly) int64_t epochNanos;

/// 初始化方法
/// @param nanoTime 事件发生的时间戳
/// @param name 事件名称
- (instancetype)initWithNano:(int64_t)nanoTime name:(NSString *)name;

/// 初始化方法
/// @param nanoTime 事件的时间戳
/// @param name 事件名
/// @param attributes 特征键值对数组
/// @param capacity 事件允许储存的最大特征键值对数
- (instancetype)initWithNano:(int64_t)nanoTime name:(NSString *)name attributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity;

/// 基于另一事件初始化事件
/// @param nanoTime 事件时间戳
/// @param event 参数事件
/// @param capacity 允许储存的最大键值对数
- (instancetype)initWithNano:(int64_t)nanoTime event:(OTEvent *)event capacity:(NSInteger)capacity;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
