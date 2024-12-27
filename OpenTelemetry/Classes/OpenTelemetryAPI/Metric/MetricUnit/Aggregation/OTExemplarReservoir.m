//
//  OTExemplarReservoir.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTExemplarReservoir.h"
#import "OTSafeArray.h"
#import "OTExemplar.h"
#import "OTMeasurement.h"
#import "OTClock.h"
#import "OTContextProtocol.h"
#import "OTExemplarFilter.h"
#import "OTDependencyDefine.h"

@interface OTExemplarReservoir ()

@end

@implementation OTExemplarReservoir

#pragma mark - Getter & Setter

- (id<OTClockProtocol>)clock {
    if (!_clock) {
        _clock = [[OTClock alloc] init];
    }
    return _clock;
}

- (id<OTExemplarFilterProtocol>)filter {
    if (!_filter) {
        _filter = [[OTExemplarFilter alloc] init];
    }
    return _filter;
}

#pragma mark - Private

- (OTExemplar *)generateExemplarWithMeasurement:(OTMeasurement *)measurement {
    OTExemplar *exemplar = [[OTExemplar alloc] init];
    exemplar.filteredAttributes = measurement.attributes;
    exemplar.timeUnixNano = [self.clock nanoSecondTime];
    exemplar.value = measurement.value;
    exemplar.valueType = measurement.valueType;
    id<OTContextProtocol> context = nil;
#ifdef OT_TRACING_SDK_SPAN
    context = [self.tracerProvider.currentTracer currentActiveSpan].context;
#endif
    if (self.offeredContextCallback) {
        context = self.offeredContextCallback(measurement);
    }
    exemplar.spanId = context.spanIdString;
    exemplar.traceId = context.traceIdString;
    return exemplar;
}

#pragma mark - Public

- (OTExemplar *)exemplarConvertedFromMeasurement:(OTMeasurement *)measurement {
    if (![self.filter shouldSampleMeasurement:measurement]) {
        return nil;
    }
    OTExemplar *exemplar = [self generateExemplarWithMeasurement:measurement];
    return exemplar;
}

@end
