//
//  OTLoggingKeyValue.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/25.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingKeyValue.h"
#import "OTLoggingAnyValue.h"
#import "OTLogDataReportKeys.h"

@interface OTLoggingKeyValueModel ()

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) OTLoggingAnyValue *anyValue;

@end

@implementation OTLoggingKeyValueModel

- (instancetype)initWithKey:(NSString *)key value:(OTLoggingAnyValue *)value {
    if (self = [super init]) {
        _key = key;
        _anyValue = value;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    NSDictionary *valueJson = [self.anyValue toJson];
    if (self.key.length && valueJson) {
        [jsonObject setValue:self.key forKey:OTLoggingKeyValue_key];
        [jsonObject setValue:valueJson forKey:OTLoggingKeyValue_value];
    }
    return jsonObject.copy;
}

@end

@interface OTLoggingKeyValueListModel ()
@property (nonatomic, copy) NSArray<OTLoggingKeyValueModel *> *values;
@end

@implementation OTLoggingKeyValueListModel

- (instancetype)initWithValues:(NSArray<OTLoggingKeyValueModel *> *)values {
    if (self = [super init]) {
        _values = values;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *jsonObjects = [NSMutableArray array];
    [self.values enumerateObjectsUsingBlock:^(OTLoggingKeyValueModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *valueJson = [obj toJson];
        if (valueJson) {
            [jsonObjects addObject:valueJson];
        }
    }];
    [result setValue:jsonObjects forKey:OTLoggingKeyValue_values];
    return result.copy;
}

@end

@interface OTLoggingArrayValueModel ()
@property (nonatomic, copy) NSArray<OTLoggingAnyValue *> *values;
@end

@implementation OTLoggingArrayValueModel

- (instancetype)initWithValues:(NSArray<OTLoggingAnyValue *> *)values {
    if (self = [super init]) {
        _values = values;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *jsonObjects = [NSMutableArray array];
    [self.values enumerateObjectsUsingBlock:^(OTLoggingAnyValue *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *valueJson = [obj toJson];
        if (valueJson) {
            [jsonObjects addObject:valueJson];
        }
    }];
    [result setValue:jsonObjects forKey:OTLoggingKeyValue_values];
    return result.copy;
}

@end
