//
//  OTCommonDefine.h
//  Pods
//
//  Created by angelehao on 2024/3/10.
//

#ifndef OTCommonDefine_h
#define OTCommonDefine_h

typedef NS_ENUM(NSInteger, OTResourceEnvironment) {
    /// 上传正式环境
    OTResourceEnvironment_Production,
    /// 上传测试环境
    OTResourceEnvironment_Devlopement
};
/// SDK内部指定
static NSString * const gOTFrameWorkVersion = @"1.2.22.3.11";

static NSString * const gOTResourceAttributeKey_Target = @"target";

static NSString * const gOTResourceAttributeKey_NameSpace = @"namespace";



#endif /* OTCommonDefine_h */
