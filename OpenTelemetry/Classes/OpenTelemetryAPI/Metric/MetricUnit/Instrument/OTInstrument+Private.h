//
//  OTInstrument+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTInstrument.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTInstrument (Private)

/// this block is defined by user,  which will called if the metric reader need to create an new data point
@property (nonatomic, copy) OTObservableMeasurementBlock observableCallback;

/// The kind of the Instrument - whether it is a Counter or other instruments, whether it is synchronous or asynchronous
@property (nonatomic, assign) OTInstrumentType type;

/// value type of the instrument
@property (nonatomic, assign) OTNumericValueType valueType;

/// See OTInstrumentDelegate above
@property (nonatomic, weak) id<OTInstrumentDelegate> delegate;

/// The name of the Instrument
@property (nonatomic, copy) NSString *name;

/// An optional description
@property (nonatomic, copy) NSString *descriptionInfo;

/// An optional unit of measure
@property (nonatomic, copy) NSString *unit;

/// update value change to instrument's aggregator
/// @param value value
/// @param attributes attributes
- (void)updateAggregator:(NSNumber *)value attributes:(OTSafeArray<OTAttribute *> *)attributes;

/// instrument will triggered an observable callback when this method is called
- (void)triggeredObservableCallback;

@end

NS_ASSUME_NONNULL_END
