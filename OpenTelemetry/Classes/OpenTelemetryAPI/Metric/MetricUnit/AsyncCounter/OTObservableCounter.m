//
//  OTObservableCounter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTObservableCounter.h"
#import "OTInstrument+Private.h"

@implementation OTObservableCounter

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeObservableCounter;
    }
    return self;
}

@end
