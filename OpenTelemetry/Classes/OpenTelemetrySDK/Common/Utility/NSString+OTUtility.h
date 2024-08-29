//
//  NSString+OTUtility.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/24.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OTUtility)

- (NSUInteger)ot_numberWithHexString;

- (NSString *)ot_base64StringFromHexString;

- (NSString *)ot_hexStringFromBase64String;

+ (NSData *)ot_dataFromHexadecimalString:(NSString *)hexString;

#pragma mark - load function

void loadOTUtilltyMethods(void);

@end

NS_ASSUME_NONNULL_END
