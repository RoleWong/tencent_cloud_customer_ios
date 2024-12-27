//
//  NSNumber+OTJsonTools.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NSNumber+OTJsonTools.h"

@implementation NSNumber (OTJsonTools)

- (NSString *)ot_toIntegerString {
    return [NSString stringWithFormat:@"%ld", (long)self.integerValue];
}

- (NSString *)ot_toDoubleString {
    return [NSString stringWithFormat:@"%f", self.doubleValue];
}

@end
