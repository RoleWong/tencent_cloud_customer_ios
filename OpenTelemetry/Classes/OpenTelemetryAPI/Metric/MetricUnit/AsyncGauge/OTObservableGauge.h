//
//  OTObservableGauge.h
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTInstrument.h"

NS_ASSUME_NONNULL_BEGIN

/// Observable guage is an instrument that create measurement value asynchronizly, its value can be negative
@interface OTObservableGauge : OTInstrument

- (instancetype)initWithType:(OTInstrumentType)type NS_UNAVAILABLE;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
