//
//  OTCounter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTCounter.h"
#import "OTInstrument+Private.h"

@implementation OTCounter

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeCounter;
    }
    return self;
}

- (void)add:(NSInteger)value attibutes:(NSDictionary<NSString *, NSString *> *)attributes {
    // return if the value is below zero
    if (value < 0) {
        return;
    }
    [super add:value attibutes:attributes];
}

- (void)addDouble:(NSTimeInterval)value attibutes:(NSDictionary<NSString *, NSString *> *)attributes {
    // return if the value is bleow zero
    if (value < 0) {
        return;
    }
    [super addDouble:value attibutes:attributes];
}

@end
