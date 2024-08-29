//
//  AttributesWithCapacity.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/27.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"

@interface OTAttributesWithCapacity ()

@property (nonatomic, strong) OTSafeDictionary *mutableDict;
@property (nonatomic, strong) OTSafeArray *mutableArray;
@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, assign) NSInteger droppedCount;

@end

@implementation OTAttributesWithCapacity

- (instancetype)initWithCapacity:(NSInteger)capacity {
    if (self = [super init]) {
        if (capacity > 0) {
            _capacity = capacity;
        }
        _mutableDict = [[OTSafeDictionary alloc] init];
        _mutableArray = [[OTSafeArray alloc] init];
    }
    return self;
}

- (void)updateAttributes:(NSArray<OTAttribute *> *)attributes {
    for (OTAttribute *sampleAttribute in attributes) {
        [self updateAttribute:sampleAttribute];
    }
}

- (void)updateAttribute:(OTAttribute *)attribute {
    if (!attribute) {
        return;
    }
    if (self.capacity == 0) {
        // capcacity equals to zero, just return.
        return;
    }
    // find out if the same attribute key was stored
    if ([self.mutableDict objectForKey:attribute.key]) {
        // attribute already exist
        if (attribute.nullValue) {
            // if attribute value is NULL, remove this key.
            [self removeAttribute:attribute];
        } else {
            // replace it with new one
            OTAttribute *oldAttribute = [self.mutableDict objectForKey:attribute.key];
            [self removeAttribute:oldAttribute];
            [self appendAttribute:attribute];
        }
    } else {
        // is it reach the capacity limit?
        if (self.capacity <= self.mutableArray.count) {
            // overwhelming , drop the first atrribute
            [self removeAttributeAtIndex:0];
            [self appendAttribute:attribute];
            self.droppedCount += 1; // add the counter
        } else {
            [self appendAttribute:attribute];
        }
    }
}

- (void)removeAttributeForKey:(NSString *)key {
    if (key.length == 0) {
        return;
    }
    OTAttribute *attriObject = [self.mutableDict objectForKey:key];
    if (attriObject) {
        [self.mutableArray removeObject:attriObject];
        [self.mutableDict removeObjectForKey:key];
    }
}

- (void)removeAttributeAtIndex:(NSUInteger)index {
    if (index >= self.mutableArray.count) {
        return;
    }
    OTAttribute *attriObject = [self.mutableArray objectAtIndex:index];
    [self.mutableArray removeObjectAtIndex:index];
    [self.mutableDict removeObjectForKey:attriObject.key];
}

- (void)removeAttribute:(OTAttribute *)attribute {
    if (!attribute) {
        return;
    }
    OTAttribute *stashedAttribute = [self.mutableDict objectForKey:attribute.key];
    [self.mutableDict removeObjectForKey:attribute.key];
    [self.mutableArray removeObject:stashedAttribute];
}

- (void)appendAttribute:(OTAttribute *)attribute {
    if (!attribute) {
        return;
    }
    [self.mutableArray addObject:attribute];
    [self.mutableDict setValue:attribute forKey:attribute.key];
}

- (NSArray<OTAttribute *> *)attributes {
    return [self.mutableArray fetchArray];
}

- (OTAttribute *)attributeForKey:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    OTAttribute *ret = nil;
    ret = [self.mutableDict objectForKey:key];
    return ret;
}

- (OTAttribute *)attributeAtIndex:(NSUInteger)index {
    if (index >= _mutableArray.count) {
        return nil;
    }
    OTAttribute *ret = nil;
    ret = [self.mutableArray objectAtIndex:index];
    return ret;
}

+ (OTAttributesWithCapacity *)attributesCollectionWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    NSArray *allKeys = dictionary.allKeys;
    OTSafeArray *mutableArray = [[OTSafeArray alloc] init];
    [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSObject *value = dictionary[key];
        NSString *valueString = [value description];
        OTAttribute *attribute = [OTAttribute attributeWithKey:key stringValue:valueString];
        [mutableArray addObject:attribute];
    }];
    OTAttributesWithCapacity *attributes = [[OTAttributesWithCapacity alloc] initWithCapacity:allKeys.count];
    [attributes updateAttributes:[mutableArray fetchArray]];
    return attributes;
}

- (NSUInteger)count {
    NSUInteger result = NSUIntegerMax;
    result = self.mutableArray.count;
    return result;
}

- (NSString *)w3cFormattedString {
    NSMutableArray *w3cParts = [[NSMutableArray alloc] init];
    [self.mutableArray enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *w3cPart = [NSString stringWithFormat:@"%@=%@", obj.key, obj.stringValue];
        [w3cParts addObject:w3cPart];
    }];
    NSString *resultString = [w3cParts componentsJoinedByString:@","];
    return resultString;
}

@end
