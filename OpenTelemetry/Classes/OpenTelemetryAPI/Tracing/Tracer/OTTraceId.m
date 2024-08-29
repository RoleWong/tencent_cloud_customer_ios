//
//  OTTraceId.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTraceId.h"

#import "OTDependencyDefine.h"

NSUInteger const gTraceIdLength = 16;

@interface OTTraceId ()

@property (nonatomic, copy) NSString *hexString;

@end

@implementation OTTraceId

- (instancetype)initWithHexString:(NSString *)hexString {
    self = [super init];
    if (self) {
        _hexString = hexString;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TraceId[%@]", self.hexString];
}

- (BOOL)isEqualToTraceId:(OTTraceId *)traceId {
    return [self.hexString isEqualToString:traceId.hexString];
}

- (BOOL)isValid {
    if (self.hexString.length == kInvalidID) {
        return NO;
    }
    if (self.hexString.length != gTraceIdLength * 2) {
        return NO;
    }
    return YES;
}

@end
