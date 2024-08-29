//
//  Resource.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTResource.h"
#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"
#import "OTResourceUtil.h"


@interface OTResource ()

{
    OTAttributesWithCapacity *_mutableAttributes;
}

@end

NSString *const gDeviceIdKey = @"device_id";

NSString *const gOTLogsDataKeyLogs = @"logs";

@implementation OTResource



- (instancetype)initWithAttributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        // need deviceId
        __block BOOL needDeviceId = YES;
        [attributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj.key isEqualToString:gDeviceIdKey]) {
                needDeviceId = NO;
                return;
            }
        }];
        NSUInteger trueCapacity = needDeviceId ? capacity + 1 : capacity;
        NSMutableArray *fullAttributes = [[NSMutableArray alloc] initWithArray:attributes];
        if (needDeviceId) {
            // generate device id
            NSString *deviceId = [[NSUUID UUID] UUIDString];
            OTAttribute *deviceIdAttribute = [OTAttribute attributeWithKey:gDeviceIdKey stringValue:deviceId];
            [fullAttributes addObject:deviceIdAttribute];
        }
        _mutableAttributes = [[OTAttributesWithCapacity alloc] initWithCapacity:trueCapacity];
        [_mutableAttributes updateAttributes:fullAttributes];
        // 只跟Log相关
        _logExportDataKey = gOTLogsDataKeyLogs;
       
    }
    return self;
}

+ (instancetype)resourceWithAttributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity {
    OTResource *resource = [[OTResource alloc] initWithAttributes:attributes capacity:capacity];
    return resource;
}

+ (nonnull instancetype)resourceWithTarget:(nonnull NSString *)targetName environment:(OTResourceEnvironment)environment {
    return [self resourceWithTarget:targetName environment:environment extraInfo:nil];
}

+ (nonnull instancetype)resourceWithTarget:(nonnull NSString *)targetName environment:(OTResourceEnvironment)environment extraInfo:(nullable NSDictionary *)extraInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (extraInfo.count) {
        [dict addEntriesFromDictionary:extraInfo];
    }
    NSDictionary *attributesDict = [OTResourceUtil generateResourceAttributesWithTarget:targetName environment:environment];
    [dict addEntriesFromDictionary:attributesDict];
    OTAttributesWithCapacity *attributes = [OTAttributesWithCapacity attributesCollectionWithDictionary:[dict copy]];
    NSArray *attributeArray = attributes.attributes;
    return [OTResource resourceWithAttributes:attributeArray capacity:attributeArray.count];
}

+ (instancetype)resourceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    OTAttributesWithCapacity *attributes = [OTAttributesWithCapacity attributesCollectionWithDictionary:dictionary];
    NSArray *attributeArray = attributes.attributes;
    return [OTResource resourceWithAttributes:attributeArray capacity:attributeArray.count];
}

- (NSArray<OTAttribute *> *)attributes {
    return _mutableAttributes.attributes;
}

- (instancetype)mergeWithResource:(OTResource *)resource {
    NSMutableArray *mutableAttributes = [[NSMutableArray<OTAttribute *> alloc] init];
    [mutableAttributes addObjectsFromArray:self.attributes];
    [mutableAttributes addObjectsFromArray:resource.attributes];
    return [[OTResource alloc] initWithAttributes:mutableAttributes capacity:mutableAttributes.count];
}

+ (instancetype)mergeResource:(OTResource *)resource1 andResources:(OTResource *)resource2 {
    return [resource1 mergeWithResource:resource2];
}

- (NSString *)stringValueForKey:(NSString *)key {
    OTAttribute *attri = [_mutableAttributes attributeForKey:key];
    return attri.stringValue;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    NSMutableArray *attris = [NSMutableArray array];
    for (OTAttribute *attri in self.attributes) {
        [attris addObject:attri.toJson];
    }
    [json setValue:attris forKey:@"attributes"];
    return json;
}

- (void)updateAttributeValue:(NSString *)value withKey:(NSString *)key {
    if (key.length <= 0 || value.length <= 0) {
        return;
    }
    OTAttribute *needUpdateAttribute = [OTAttribute attributeWithKey:key stringValue:value];
    [_mutableAttributes updateAttribute:needUpdateAttribute];
}



@end
