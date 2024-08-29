//
//  OTRandomIdsGenerator.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTRandomIdsGenerator.h"
#import "OTSpanId.h"
#import "OTTraceId.h"

static NSUInteger const kMaxByte = 255;

@implementation OTRandomIdsGenerator

- (NSString *)randomByteValue {
    NSUInteger byteRawValue = arc4random() % kMaxByte;
    NSString *byteString = [NSString stringWithFormat:@"%02lx", (unsigned long)byteRawValue];
    return byteString;
}

- (OTSpanId *)generateSpanId {
    NSMutableString *hexId = [[NSMutableString alloc] init];
    for (NSInteger index = 0; index < gSpanIdLength; index ++) {
        NSString *bytePart = [self randomByteValue];
        [hexId appendString:bytePart];
    }
    return [[OTSpanId alloc] initWithHexString:hexId];
}

- (OTTraceId *)generateTraceId {
    NSMutableString *hexId = [[NSMutableString alloc] init];
    for (NSInteger index = 0; index < gTraceIdLength; index ++) {
        NSString *bytePart = [self randomByteValue];
        [hexId appendString:bytePart];
    }
    return [[OTTraceId alloc] initWithHexString:hexId];
}

@end
