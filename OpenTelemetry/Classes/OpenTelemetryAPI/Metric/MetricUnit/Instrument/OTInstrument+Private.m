//
//  OTInstrument+Private.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTInstrument+Private.h"
#import "OTMeasurement+Private.h"

@implementation OTInstrument (Private)

@dynamic observableCallback;
@dynamic type;
@dynamic valueType;
@dynamic delegate;
@dynamic name;
@dynamic descriptionInfo;
@dynamic unit;

- (void)updateAggregator:(NSNumber *)value attributes:(OTSafeArray<OTAttribute *> *)attributes {
    @autoreleasepool {
        OTMeasurement *measurement = [[OTMeasurement alloc] initWithValue:value valueType:self.valueType attributes:attributes];
        measurement.name = self.name;
        measurement.descriptionInfo = self.descriptionInfo;
        measurement.unit = self.unit;
        if ([self.delegate respondsToSelector:@selector(instrument:triggeredWithMeasurement:)]) {
            [self.delegate instrument:self triggeredWithMeasurement:measurement];
        }
    }
}

- (void)triggeredObservableCallback {
    @autoreleasepool {
        OTMeasurement *measurement = [[OTMeasurement alloc] initWithValue:@0 valueType:self.valueType attributes:nil];
        measurement.name = self.name;
        measurement.descriptionInfo = self.descriptionInfo;
        measurement.unit = self.unit;
        // pass the measurement to observableCallback let user to config the value and attributes
        if (!self.observableCallback) {
            return;
        }
        self.observableCallback(measurement);
        // offer this measurement
        if ([self.delegate respondsToSelector:@selector(instrument:triggeredWithMeasurement:)]) {
            [self.delegate instrument:self triggeredWithMeasurement:measurement];
        }
    }
}

@end
