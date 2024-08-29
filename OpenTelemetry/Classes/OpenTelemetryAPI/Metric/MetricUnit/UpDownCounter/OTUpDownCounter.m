//
//  OTUpDownCounter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTUpDownCounter.h"
#import "OTMeasurement.h"
#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeDictionary.h"
#import "OTInstrument+Private.h"

@interface OTUpDownCounter ()

@end

@implementation OTUpDownCounter

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeUpDownCounter;
    }
    return self;
}

- (void)add:(NSInteger)value attibutes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (self.valueType != OTNumericValueTypeLong) {
        return;
    }
    // accept value below zero
    NSNumber *valueNumber = [[NSNumber alloc] initWithLong:value];

    OTSafeArray *fullAttributes = [self fullAttributesWithAttributes:attributes];
    [self updateAggregator:valueNumber attributes:fullAttributes];
}

- (void)addDouble:(NSTimeInterval)value attibutes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (self.valueType != OTNumericValueTypeDouble) {
        return;
    }
    // accept value below zero
    NSNumber *valueNumber = [[NSNumber alloc] initWithDouble:value];
    OTSafeArray *fullAttributes = [self fullAttributesWithAttributes:attributes];
    [self updateAggregator:valueNumber attributes:fullAttributes];
}

@end
