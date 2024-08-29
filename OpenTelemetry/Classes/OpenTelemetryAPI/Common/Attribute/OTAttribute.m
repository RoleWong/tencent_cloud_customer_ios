//
//  Attribute.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"
#import "NSObject+OTJsonTools.h"

/// 默认异常key value值
static NSString *const gTelemetryAttributeDefaultValue = @"上报值异常";

NS_INLINE NSString *safeAttributeAvailableString(NSString *str) {
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }
    return gTelemetryAttributeDefaultValue;
}

@interface OTAttribute()

/// key
@property (nonatomic, copy) NSString *key;

/// value
@property (nonatomic, copy) NSString *stringValue;

/// nullvalue
@property (nonatomic, strong) NSNull *nullValue;

@end

@implementation OTAttribute

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OTAttribute class]]) {
        return NO;
    }
    OTAttribute *otherAttribute = (OTAttribute *)object;
    BOOL sameKey = [self.key isEqualToString:otherAttribute.key];
    BOOL sameValue = [self.stringValue isEqualToString:otherAttribute.stringValue];
    return sameKey && sameValue;
}

- (NSString *)keyValueString {
    return [[NSString alloc] initWithFormat:@"%@=%@", self.key, self.stringValue];
}

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonAttributeDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *jsonValueDict = [[NSMutableDictionary alloc] init];
    [jsonValueDict setValue:self.stringValue forKey:@"string_value"];
    [jsonAttributeDict setValue:self.key forKey:@"key"];
    [jsonAttributeDict setValue:jsonValueDict forKey:@"value"];
    return jsonAttributeDict;
}

+ (instancetype)attributeWithKey:(NSString *)key stringValue:(NSString *)stringValue {
    if (key.length == 0 || !stringValue) {
        return nil;
    }
    OTAttribute *attribute = [[self alloc] init];
    NSString *realKey = safeAttributeAvailableString(key);
    NSString *realValue = safeAttributeAvailableString(stringValue);
    attribute.key = [realKey mutableCopy];
    attribute.stringValue = [realValue mutableCopy];
    return attribute;
}

+ (instancetype)attributeNullWithKey:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    OTAttribute *attribute = [[self alloc] init];
    attribute.key = key;
    attribute.nullValue = [NSNull null];
    return attribute;
}

+ (instancetype)attributeWithKey:(NSString *)key values:(NSArray<NSString *> *)values {
    NSString *jsonString = [values ot_jsonStringOnelineWithError:nil];
    return [self attributeWithKey:key stringValue:jsonString];
}

+ (OTSafeArray<OTAttribute *> *)attributesWithDictioanry:(NSDictionary<NSString *, NSString *> *)dictionary {
    OTSafeArray *result = [[OTSafeArray alloc] init];
    NSArray<NSString *> *allKeys = dictionary.allKeys;
    [allKeys enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *value = [dictionary objectForKey:obj];
        OTAttribute *attribute = [OTAttribute attributeWithKey:obj stringValue:value];
        if (attribute) {
            [result addObject:attribute];
        }
    }];
    return result;
}

- (NSString *)description {
    return [self keyValueString];
}

@end
