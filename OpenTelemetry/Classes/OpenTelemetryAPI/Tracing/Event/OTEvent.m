//
//  Event.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTEvent.h"
#import "OTAttributesWithCapacity.h"
#import "OTSpanDataReportKeys.h"

@interface OTEvent ()

{
    OTAttributesWithCapacity *_attributesCollection;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int64_t epochNanos;

@end

@implementation OTEvent

- (instancetype)initWithName:(NSString *)name attributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _name = name;
        _attributesCollection = [[OTAttributesWithCapacity alloc] initWithCapacity:capacity];
        [_attributesCollection updateAttributes:attributes];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name capacity:(NSInteger)capacity {
    return [self initWithName:name attributes:@[] capacity:capacity];
}

- (NSArray<OTAttribute *> *)attributes {
    return _attributesCollection.attributes;
}

- (NSInteger)droppedCount {
    return _attributesCollection.droppedCount;
}

- (instancetype)initWithNano:(int64_t)nanoTime name:(NSString *)name {
    return [self initWithNano:nanoTime name:name attributes:@[] capacity:0];
}

- (instancetype)initWithNano:(int64_t)nanoTime event:(OTEvent *)event capacity:(NSInteger)capacity {
    return [self initWithNano:nanoTime name:event.name attributes:event.attributes capacity:capacity];
}

- (instancetype)initWithNano:(int64_t)nanoTime name:(NSString *)name attributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity {
    self = [self initWithName:name attributes:attributes capacity:capacity];
    if (self) {
        _epochNanos = nanoTime;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionary];
    [jsonData setValue:self.name forKey:OTSpanDataKeyName];
    [jsonData setValue:[NSString stringWithFormat:@"%lld", self.epochNanos] forKey:OTSpanEventTimeUnixNanoKey];
    NSMutableArray *attributesJson = [NSMutableArray array];
    for (OTAttribute *attribute in self.attributes) {
        if (attribute.toJson) { // 确保元素非空避免崩溃
            [attributesJson addObject:attribute.toJson];
        }
    }
    [jsonData setValue:attributesJson forKey:OTSpanDataKeyAttributes];
    [jsonData setValue:@(_attributesCollection.droppedCount) forKey:OTSpanDroppedAttributesKey];
    return jsonData;
}

@end
