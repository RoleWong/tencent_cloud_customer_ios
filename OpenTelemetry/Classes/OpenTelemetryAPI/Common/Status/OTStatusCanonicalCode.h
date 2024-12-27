//
//  OTStatusCanonicalCode.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OTStatusCanonicalCode) {
    OTStatusCanonicalCodeUnset = 0, // 未定义
    OTStatusCanonicalCodeOk = 1,    // 正常
    OTStatusCanonicalCodeError = 2, // 错误
};
