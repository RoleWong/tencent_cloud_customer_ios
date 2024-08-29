//
//  OTLoggingKeyValue.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/25.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"

@class OTLoggingAnyValue;
NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingKeyValueModel : OTBaseObject <OTJsonConvertible>

/**
 * @brief 通过Key-Value初始化
 * @param key 键值
 * @param value OTLoggingAnyValue数据
 */
- (instancetype)initWithKey:(NSString *)key value:(OTLoggingAnyValue *)value;

@end

@interface OTLoggingKeyValueListModel : OTBaseObject <OTJsonConvertible>

/**
 * @brief 通过数组初始化
 * @param values 泛型为OTLoggingKeyValueModel的数组
 */
- (instancetype)initWithValues:(NSArray<OTLoggingKeyValueModel *> *)values;

@end

@interface OTLoggingArrayValueModel : OTBaseObject <OTJsonConvertible>

/**
 * @brief 通过数组初始化
 * @param values 泛型为OTLoggingAnyValue的数组
 */
- (instancetype)initWithValues:(NSArray<OTLoggingAnyValue *> *)values;

@end

NS_ASSUME_NONNULL_END
