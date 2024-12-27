//
//  NSObject+OTJsonTools.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OTJsonTools)

/// Convert NSObject type instance to JsonString pretty print, use as out put log mostly;
/// @param error error description
- (NSString *)ot_jsonStringWithError:(NSError **_Nullable)error;

/// Convert NSObject type instance to JsonString oneline, this method is called when transefering data;
/// @param error error description
- (NSString *)ot_jsonStringOnelineWithError:(NSError **_Nullable)error;

@end

NS_ASSUME_NONNULL_END
