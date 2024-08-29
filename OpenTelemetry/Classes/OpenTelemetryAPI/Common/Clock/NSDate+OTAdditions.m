//
//  NSDate+OTAdditions.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "NSDate+OTAdditions.h"

static const NSTimeInterval gOTTimeScaleMillisecond = 1000.f;
static const NSTimeInterval gOTTimeScaleNanosecond = 1000000000.f;

@implementation NSDate (OTAdditions)

- (NSTimeInterval)ot_nanoSecond {
    NSTimeInterval second = [self timeIntervalSince1970];
    NSTimeInterval result = (NSTimeInterval)second * gOTTimeScaleNanosecond;
    return result;
}

- (NSTimeInterval)ot_milliSecond {
    NSTimeInterval second = [self timeIntervalSince1970];
    NSTimeInterval result = (NSTimeInterval)second * gOTTimeScaleMillisecond;
    return result;
}

@end
