//
//  OTUpDownCounter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrument.h"

NS_ASSUME_NONNULL_BEGIN

/// Counter is an instrument creating increment value called by user. Its value can be negateive
@interface OTUpDownCounter : OTInstrument

- (instancetype)initWithType:(OTInstrumentType)type NS_UNAVAILABLE;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Increment or decrement the UpDownCounter by a fixed amount
/// @param value long value, can be non-negative or negative
/// @param attributes attributes represent as string-string dictionary
- (void)add:(NSInteger)value attibutes:(NSDictionary<NSString *, NSString *> *_Nullable)attributes;

/// Increment or decrement the UpDownCounter by a fixed amount
/// @param value double value, can be non-negative or negative
/// @param attributes attributes represent as string-string dictionary
- (void)addDouble:(NSTimeInterval)value attibutes:(NSDictionary<NSString *, NSString *> *_Nullable)attributes;

@end

NS_ASSUME_NONNULL_END
