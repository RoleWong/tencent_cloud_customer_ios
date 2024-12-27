//
//  OTLoggingAnyValue.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/17.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingAnyValue : OTBaseObject <OTJsonConvertible>

/**
 * @brief 通过NSString类型初始化
 * @param value 传入NSString类型的数据
 */
- (instancetype)initWithString:(NSString *)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过BOO;类型初始化
 * @param value 传入BOOL;类型的数据
 */
- (instancetype)initWithBool:(BOOL)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过int64_t类型初始化
 * @param value 传入int64_t类型的数据
 */
- (instancetype)initWithInt64:(int64_t)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过double类型初始化
 * @param value 传入double类型的数据
 */
- (instancetype)initWithDouble:(double)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过NSArray类型初始化，数组中数据泛型为OTLoggingAnyValue
 * @param value 传入NSArray类型的数据\
 */
- (instancetype)initWithArray:(NSArray<OTLoggingAnyValue *> *)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过Key-Value初始化，最终输出是Key-Value数组
 * @param key 键值
 * @param value OTLoggingAnyValue的数据
 */
- (instancetype)initWithKey:(NSString *)key value:(OTLoggingAnyValue *)value NS_DESIGNATED_INITIALIZER;

/**
 * @brief 通过Key-Value数组初始化，最终输出是Key-Value数组
 * @param keys 键值数组
 * @param values 泛型为OTLoggingAnyValue的数组
 */
- (instancetype)initWithKeys:(NSArray<NSString *> *)keys values:(NSArray<OTLoggingAnyValue *> *)values NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
