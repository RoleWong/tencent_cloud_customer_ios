//
//  OTObservableGauge.m
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTObservableGauge.h"
#import "OTInstrument+Private.h"

@implementation OTObservableGauge

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTInstrumentTypeObservableGauge;
    }
    return self;
}

@end
