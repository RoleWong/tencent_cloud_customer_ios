//
//  OTResourceUtil.m
//  OpenTelemetry
//
//  Created by angelehao on 2024/3/10.
//

#import "OTResourceUtil.h"

#pragma mark - 客户端兜底值

static NSString * const gOTResourceTargetPrefix = @"iOS.";
static NSString * const gOTResourceAttributeKey_Version = @"version";
static NSString * const gOTResourceAttributeKey_Language = @"telemetry.sdk.language";
static NSString * const gOTResourceAttributeKey_SDK_Name = @"telemetry.sdk.name";
/// 对应的资源名称, 为target 去掉平台的值
static NSString * const gOTResourceAttributeKey_ServiceName = @"service.name";
/// 在log情况下专属字段,和service.name相同
static NSString * const gOTResourceAttributeKey_Server = @"server";
/// 历史原因,导致客户端还需要上传trpc.namespace, 该值和namespace相同
static NSString * const gOTResourceAttributeKey_TRPC_NameSpace = @"trpc.namespace";

#pragma mark - trace 下搜索字段,适配后台接口,客户端传空字符串
static NSString * const gOTResourceAttributeKey_TRPC_EnvName = @"trpc.envname";
static NSString * const gOTResourceAttributeKey_ENV = @"env";
static NSString * const gOTResourceAttributeKey_ENV_Name = @"env_name";
static NSString * const gOTResourceAttributeKey_Instance = @"instance";
static NSString * const gOTResourceAttributeKey_Container_Name = @"container_name";
static NSString * const gOTResourceAttributeKey_Con_SetId = @"con_setid";
static NSString * const gOTResourceAttributeKey_Region = @"region";

#pragma mark - OTResourceUtil imp
@implementation OTResourceUtil

+ (NSDictionary *)commonResourceAttributes {
    NSDictionary *commonResourceAttributes = @{
        gOTResourceAttributeKey_Version: gOTFrameWorkVersion, // 必填：版本号 value可为空字符
        gOTResourceAttributeKey_Language : @"objc",
        gOTResourceAttributeKey_SDK_Name : @"galileo",
        gOTResourceAttributeKey_TRPC_EnvName : @"",
        gOTResourceAttributeKey_ENV : @"",
        gOTResourceAttributeKey_ENV_Name : @"",
        gOTResourceAttributeKey_Instance : @"",
        gOTResourceAttributeKey_Container_Name : @"",
        gOTResourceAttributeKey_Con_SetId : @"",
        gOTResourceAttributeKey_Region : @"",
    };
    return commonResourceAttributes;
}

+ (NSDictionary *)generateResourceAttributesWithTarget:(NSString *)targetName environment:(OTResourceEnvironment)environment {
    NSAssert(targetName.length != 0, @"target must be nonnull");
    NSString *name = [targetName substringWithRange:NSMakeRange(gOTResourceTargetPrefix.length, targetName.length - gOTResourceTargetPrefix.length)];
    NSAssert(name.length != 0, @"service.name must be nonnull");
    NSDictionary *commonAtt = [OTResourceUtil commonResourceAttributes];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:commonAtt];
    dict[gOTResourceAttributeKey_Target] = targetName;
    if (environment == OTResourceEnvironment_Production) {
        dict[gOTResourceAttributeKey_NameSpace] = @"Production";
        dict[gOTResourceAttributeKey_TRPC_NameSpace] = @"Production";
    } else if (environment == OTResourceEnvironment_Devlopement) {
        dict[gOTResourceAttributeKey_NameSpace] = @"Development";
        dict[gOTResourceAttributeKey_TRPC_NameSpace] = @"Development";
    } else {
        NSAssert(NO, @"NO define enum, please check params");
    }
    dict[gOTResourceAttributeKey_ServiceName] = name;
    dict[gOTResourceAttributeKey_Server] = name;
    return dict.copy;
}

@end
