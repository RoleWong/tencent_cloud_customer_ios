//
//  TraceState.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTraceState.h"
#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"

@interface OTTraceState ()

@property (nonatomic, strong) OTAttributesWithCapacity *keyValuePairs;

@end

@implementation OTTraceState

- (instancetype)initWithAttributes:(NSArray<OTAttribute *> *)attributes {
    self = [super init];
    if (self) {
        _keyValuePairs = [[OTAttributesWithCapacity alloc] initWithCapacity:5];
        [_keyValuePairs updateAttributes:attributes];
    }
    return self;
}

- (nullable instancetype)initWithSerialization:(NSString *)traceStateSerialization {
    NSArray *componts = [traceStateSerialization componentsSeparatedByString:@","];
    if (componts.count == 0) {
        return nil;
    }
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for (NSString *keValuePair in componts) {
        NSArray *keyValues = [keValuePair componentsSeparatedByString:@"="];
        OTAttribute *attribute = [OTAttribute attributeWithKey:keyValues.firstObject stringValue:keyValues.lastObject];
        [attributes addObject:attribute];
    }
    return [[self.class alloc] initWithAttributes:attributes];
}

- (void)updateValue:(NSString *)value key:(NSString *)key {
    key = key.lowercaseString; // TraceState只允许小写key
    if (!value) {
        OTAttribute *empty = [OTAttribute attributeNullWithKey:key];
        [_keyValuePairs updateAttribute:empty];
    } else {
        OTAttribute *attribute = [OTAttribute attributeWithKey:key stringValue:value];
        [_keyValuePairs updateAttribute:attribute];
    }
}

- (NSString *)serializationString {
    NSMutableArray *pairs = [NSMutableArray array];
    for (OTAttribute *attribute in self.keyValuePairs.attributes) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", attribute.key, attribute.stringValue];
        [pairs addObject:pair];
    }
    return [pairs componentsJoinedByString:@","];
}

@end
