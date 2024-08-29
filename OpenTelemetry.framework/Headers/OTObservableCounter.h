//
//  OTObservableCounter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrument.h"

NS_ASSUME_NONNULL_BEGIN

/// an observable counter is an insturment that create increment mesurement asynchronizly, its value must be non-negative
@interface OTObservableCounter : OTInstrument

- (instancetype)initWithType:(OTInstrumentType)type NS_UNAVAILABLE;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
