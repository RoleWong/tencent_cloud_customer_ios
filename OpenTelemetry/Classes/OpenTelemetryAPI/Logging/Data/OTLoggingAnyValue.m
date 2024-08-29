//
//  OTLoggingAnyValue.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/17.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingAnyValue.h"
#import "OTLoggingKeyValue.h"
#import "OTLogDataReportKeys.h"

typedef NS_ENUM(NSInteger, OTLoggingAnyValueType) {
    OTLoggingAnyValueTypeString,
    OTLoggingAnyValueTypeBool,
    OTLoggingAnyValueTypeInt64,
    OTLoggingAnyValueTypeDouble,
    OTLoggingAnyValueTypeArray,
    OTLoggingAnyValueTypeKvList
};

@interface OTLoggingAnyValue ()
@property (nonatomic, assign) OTLoggingAnyValueType type; /// 最终的数据类型
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, assign) BOOL boolValue;
@property (nonatomic, assign) int64_t int64Value;
@property (nonatomic, assign) double doubleValue;
@property (nonatomic, copy) NSArray<OTLoggingAnyValue *> *arrayValue;
@property (nonatomic, copy) NSArray<OTLoggingKeyValueModel *> *kvList;
@end

@implementation OTLoggingAnyValue

- (instancetype)initWithString:(NSString *)value {
    if (self = [super init]) {
        _stringValue = value;
        _type = OTLoggingAnyValueTypeString;
    }
    return self;
}

- (instancetype)initWithBool:(BOOL)value {
    if (self = [super init]) {
        _boolValue = value;
        _type = OTLoggingAnyValueTypeBool;
    }
    return self;
}

- (instancetype)initWithInt64:(int64_t)value {
    if (self = [super init]) {
        _int64Value = value;
        _type = OTLoggingAnyValueTypeInt64;
    }
    return self;
}

- (instancetype)initWithDouble:(double)value {
    if (self = [super init]) {
        _doubleValue = value;
        _type = OTLoggingAnyValueTypeDouble;
    }
    return self;
}

- (instancetype)initWithArray:(NSArray<OTLoggingAnyValue *> *)value {
    if (self = [super init]) {
        _arrayValue = value;
        _type = OTLoggingAnyValueTypeArray;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key value:(OTLoggingAnyValue *)value {
    if (self = [super init]) {
        OTLoggingKeyValueModel *keyValue = [[OTLoggingKeyValueModel alloc] initWithKey:key value:value];
        _kvList = @[ keyValue ];
        _type = OTLoggingAnyValueTypeKvList;
    }
    return self;
}

- (instancetype)initWithKeys:(NSArray<NSString *> *)keys values:(NSArray<OTLoggingAnyValue *> *)values {
    if (self = [super init]) {
        [self appendKvListWithKeys:keys values:values];
        _type = OTLoggingAnyValueTypeKvList;
    }
    return self;
}

- (void)appendKvListWithKeys:(NSArray<NSString *> *)keys values:(NSArray<OTLoggingAnyValue *> *)values {
    NSInteger keysCount = keys.count;
    NSInteger valuesCount = values.count;
    if (keysCount != valuesCount) {
        NSAssert(keysCount == valuesCount, @"Error, keys count is not equal to values count");
        return;
    }
    NSMutableArray *keyValueList = [NSMutableArray array];
    NSInteger index = 0;
    while (index < keysCount) {
        NSString *key = keys[index];
        OTLoggingAnyValue *value = values[index];
        OTLoggingKeyValueModel *keyValue = [[OTLoggingKeyValueModel alloc] initWithKey:key value:value];
        [keyValueList addObject:keyValue];
        index++;
    }
    _kvList = keyValueList.copy;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    switch (self.type) {
        case OTLoggingAnyValueTypeString: {
            [result setValue:self.stringValue forKey:OTLoggingAnyValueType_string];
        } break;
        case OTLoggingAnyValueTypeArray: {
            OTLoggingArrayValueModel *valueModel = [[OTLoggingArrayValueModel alloc] initWithValues:self.arrayValue];
            NSDictionary *arrayResult = [valueModel toJson];
            [result setValue:arrayResult forKey:OTLoggingAnyValueType_array];
        } break;
        case OTLoggingAnyValueTypeKvList: {
            OTLoggingKeyValueListModel *kvListModel = [[OTLoggingKeyValueListModel alloc] initWithValues:self.kvList];
            NSDictionary *kvListResult = [kvListModel toJson];
            [result setValue:kvListResult forKey:OTLoggingAnyValueType_kvlist];
        } break;
        case OTLoggingAnyValueTypeBool: {
            [result setValue:@(self.boolValue) forKey:OTLoggingAnyValueType_bool];
        } break;
        case OTLoggingAnyValueTypeInt64: {
            [result setValue:@(self.int64Value) forKey:OTLoggingAnyValueType_int];
        } break;
        case OTLoggingAnyValueTypeDouble: {
            [result setValue:@(self.doubleValue) forKey:OTLoggingAnyValueType_double];
        } break;
    }
    return result.copy;
}

@end
