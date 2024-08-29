//
//  NSNumber+OTJsonTools.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (OTJsonTools)

@property (nonatomic, copy, readonly) NSString *ot_toIntegerString;

@property (nonatomic, copy, readonly) NSString *ot_toDoubleString;

@end

NS_ASSUME_NONNULL_END
