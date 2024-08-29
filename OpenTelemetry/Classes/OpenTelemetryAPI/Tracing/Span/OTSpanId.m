//
//  SpanId.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpanId.h"

#import "OTDependencyDefine.h"

NSUInteger const gSpanIdLength = 8;

@interface OTSpanId ()

@property (nonatomic, copy) NSString *hexString;

@end

@implementation OTSpanId

- (instancetype)initWithHexString:(NSString *)hexString {
    self = [super init];
    if (self) {
        _hexString = hexString;
    }
    return self;
}

- (BOOL)isEqualToSpanId:(OTSpanId *)spanId {
    return [self.hexString isEqualToString:spanId.hexString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SpanId[%@]", self.hexString];
}

- (BOOL)isValid {
    if (self.hexString.length == kInvalidID) {
        return NO;
    }
    if (self.hexString.length != gSpanIdLength * 2) {
        return NO;
    }
    return YES;
}

@end
