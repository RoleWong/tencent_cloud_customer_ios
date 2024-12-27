//
//  OTObservableUpdownCounter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTObservableUpDownCounter.h"
#import "OTInstrument+Private.h"

@implementation OTObservableUpDownCounter

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeObservalbleUpDownCounter;
    }
    return self;
}

@end
