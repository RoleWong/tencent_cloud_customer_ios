//
//  OTHistogram.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTHistogram.h"
#import "OTMeasurement.h"
#import "OTAttributesWithCapacity.h"
#import "OTInstrument+Private.h"

@interface OTHistogram ()

/// initaial buckets for histogram to describe how the recorded value should stored in aggregator
@property (nonatomic, strong) OTSafeArray<NSNumber *> *buckets;

@end

@implementation OTHistogram

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeHistogram;
    }
    return self;
}

- (void)recordLongValue:(NSInteger)value attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (self.valueType != OTNumericValueTypeLong) {
        return;
    }
    OTSafeArray *fullAttributes = [self fullAttributesWithAttributes:attributes];
    NSNumber *valueNumber = [NSNumber numberWithLong:value];
    [self updateAggregator:valueNumber attributes:fullAttributes];
}

- (void)recordDoubleValue:(NSTimeInterval)value attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (self.valueType != OTNumericValueTypeDouble) {
        return;
    }
    OTSafeArray *fullAttributes = [self fullAttributesWithAttributes:attributes];
    NSNumber *valueNumber = [NSNumber numberWithDouble:value];
    [self updateAggregator:valueNumber attributes:fullAttributes];
}

@end
