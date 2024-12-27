//
//  OTAttribute.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

/// a representation of Key value pair
@interface OTAttribute : OTBaseObject <OTJsonConvertible>

/// key
@property (nonatomic, copy, readonly) NSString *key;

/// value represent as string
@property (nonatomic, copy, readonly) NSString *stringValue;

/// null value
@property (nonatomic, strong, readonly) NSNull *nullValue;

/// values repsresent as an array of string
@property (nonatomic, strong, readonly) NSArray <NSString *> *values;

/// represent this attribute as b3c key value pair
- (NSString *)keyValueString;

/// convenient method of creating an attribute instance
/// @param key key
/// @param stringValue value
+ (instancetype)attributeWithKey:(NSString *)key stringValue:(NSString *)stringValue;

/// convenient method of creating an attribute instance
/// @param key key
/// @param values an array of strings
+ (instancetype)attributeWithKey:(NSString *)key values:(NSArray <NSString *> *)values;

/// Initalize a null attribute
/// @param key key
+ (instancetype)attributeNullWithKey:(NSString *)key;

/// convenient method of creating attributes array
/// @param dictionary dictionary to initiaize the attribute
+ (OTSafeArray<OTAttribute *> *)attributesWithDictioanry:(NSDictionary<NSString *, NSString *> *)dictionary;

/// direct allocation of an attribute object is not allowed.
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
