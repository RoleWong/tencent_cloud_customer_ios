//
//  OTArrayWithCapacity.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/27.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"

NS_ASSUME_NONNULL_BEGIN

/// 否则使用新值替换旧值,替换后键值对的顺序移动到最后
@interface OTAttributesWithCapacity : OTBaseObject

/// 统计该集合总共舍弃了多少个键值对
@property (nonatomic, assign, readonly) NSInteger droppedCount;

/// 所有缓存的键值对
@property (nonatomic, copy, readonly) NSArray<OTAttribute *> *attributes;

/// 集合总共储存的Attribute个数
@property (nonatomic, assign, readonly) NSUInteger count;

/// 初始化特征组
/// @param capacity 最大容量
- (instancetype)initWithCapacity:(NSInteger)capacity;

/// 更新一个特征
/// @param attribute 特征
- (void)updateAttribute:(OTAttribute *)attribute;

/// 更新多个特征
/// @param attributes 特征数组
- (void)updateAttributes:(NSArray<OTAttribute *> *)attributes;

/// get attribute from key
/// @param key key
- (OTAttribute *_Nullable)attributeForKey:(NSString *)key;

/// get attribute from index
/// @param index index
- (OTAttribute *_Nullable)attributeAtIndex:(NSUInteger)index;

/// convenient method of creating an instrance of attributes colection
/// @param dictionary the dictionary used to initalze the attribute collection
+ (OTAttributesWithCapacity *)attributesCollectionWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

/// return a formatted string with w3c strandard;
- (NSString *)w3cFormattedString;

@end

NS_ASSUME_NONNULL_END
