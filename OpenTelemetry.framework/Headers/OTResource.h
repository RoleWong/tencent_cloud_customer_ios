//
//  OTResource.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAttribute.h"
#import "OTJsonConvertible.h"
#import "OTCommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// this key is to identify user's unique device in order to help tracking telemetry data
FOUNDATION_EXPORT NSString *const gDeviceIdKey;

/// Resouce is NOT a mutable object, so do not attempt to change its property after its initialization
@interface OTResource : OTBaseObject <OTJsonConvertible>

/// attributes for the resource
@property (nonatomic, copy, readonly) NSArray<OTAttribute *> *attributes;


/// convenient construct an resource object
/// @param targetName congfig target on galileo. eg: "iOS.galileo.iOSDemo"
/// @param environment upload content on enviroment
+ (instancetype)resourceWithTarget:(NSString *)targetName environment:(OTResourceEnvironment)environment;

/// convenient construct an resource object
/// @param targetName congfig target on galileo. eg: "iOS.galileo.iOSDemo"
/// @param environment upload content on enviroment
/// @param extraInfo if biz define extrainfo, this will append to resource attributes
+ (nonnull instancetype)resourceWithTarget:(nonnull NSString *)targetName environment:(OTResourceEnvironment)environment extraInfo:(nullable NSDictionary *)extraInfo;

/// convenient construct an resource object
/// @param attributes attribtues
/// @param capacity total resource attribtues count
+ (instancetype)resourceWithAttributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity;


/// designated initializer
/// @param attributes attributes array
/// @param capacity total nunber of the attributes
- (instancetype)initWithAttributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capacity NS_DESIGNATED_INITIALIZER;

/// unavailable
- (instancetype)init NS_UNAVAILABLE;

/// create a new resource object by combine this one with another resource
/// @param resource 被合并的资源对象
- (instancetype)mergeWithResource:(OTResource *)resource;

/// get string value for key
/// @param key key
- (NSString *)stringValueForKey:(NSString *)key;

/// combine two resource object two create an new resource object
/// @param resource1 resource1
/// @param resource2 resource2
+ (instancetype)mergeResource:(OTResource *)resource1 andResources:(OTResource *)resource2;

/// 上报伽利略 logs 的 key  默认初始化为logs 需更新可修改改为 log_records
@property (nonatomic, copy) NSString *logExportDataKey;

/// update attribute value with key
/// @param value update attribute value
/// @param key update attribute key
- (void)updateAttributeValue:(NSString *)value withKey:(NSString *)key;

@end

@interface OTResource(Deprecated)

/// convenient construct an resource object
/// @param dictionary attrubutes in dictionary format
+ (instancetype)resourceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary __deprecated_msg("deprecated, use OTResource.resourceWithTarget:environment: instead");

@end
NS_ASSUME_NONNULL_END
