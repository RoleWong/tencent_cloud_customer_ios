//
//  OTResourceUtil.h
//  OpenTelemetry
//
//  Created by angelehao on 2024/3/10.
//

#import <Foundation/Foundation.h>
#import "OTCommonDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTResourceUtil : NSObject

+ (NSDictionary *)generateResourceAttributesWithTarget:(NSString *)targetName environment:(OTResourceEnvironment)environment;
@end

NS_ASSUME_NONNULL_END
