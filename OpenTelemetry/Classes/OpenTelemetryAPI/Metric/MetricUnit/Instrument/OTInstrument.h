//
//  OTInstrument.h
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/8/4.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMeasurement.h"
#import "OTValueTypeDefine.h"
#import "OTAggregatorProtocol.h"
#import "OTContextProtocol.h"
#import "OTMetricView.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"

@class OTAttribute, OTInstrument;

NS_ASSUME_NONNULL_BEGIN

@protocol OTInstrumentDelegate <NSObject>

/// this method will called when user take action with the instrument, ie: a counter was added a value
/// @param instrument instrument
/// @param measurement measurement an instrument update record object
- (void)instrument:(OTInstrument *)instrument triggeredWithMeasurement:(OTMeasurement *)measurement;

@end

@interface OTInstrument : NSObject

/// this block is defined by user,  which will called if the metric reader need to create an new data point
@property (nonatomic, copy, readonly) OTObservableMeasurementBlock observableCallback;

/// The kind of the Instrument - whether it is a Counter or other instruments, whether it is synchronous or asynchronous
@property (nonatomic, assign, readonly) OTInstrumentType type;

/// value type of the instrument
@property (nonatomic, assign, readonly) OTNumericValueType valueType;

/// See OTInstrumentDelegate above
@property (nonatomic, weak, readonly) id<OTInstrumentDelegate> delegate;

/// The name of the Instrument
@property (nonatomic, copy, readonly) NSString *name;

/// An optional description
@property (nonatomic, copy, readonly) NSString *descriptionInfo;

/// An optional unit of measure
@property (nonatomic, copy, readonly) NSString *unit;

/// attributes of the instrument
@property (nonatomic, strong, readonly) NSArray<OTAttribute *> *attributes;

/// get attribute of the isntrument by key
/// @param key key description
- (OTAttribute *)attributeForKey:(NSString *)key;

/// update an attribute for the instrument
/// @param value value description
/// @param key key description
- (void)updateAttributeValue:(NSString *)value forKey:(NSString *)key;

/// udate serval attrributes for the instrument
/// @param values values description
/// @param key key description
- (void)updateAttributeValues:(OTSafeArray<NSString *> *)values forKey:(NSString *)key;

/// update an attribute for the instrument
/// @param attribute attribute description
- (void)updateAttribute:(OTAttribute *)attribute;

/// udate serval attrributes for the instrument
/// @param attributes attributes description
- (void)updateAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

/// udate serval attrributes for the instrument
/// @param attributes attributes description
- (void)updateAttributesArray:(OTSafeArray<OTAttribute *> *)attributes;

/// form attributes array with bound atrribute and a colllection of attributes
/// @param attributes attributes
- (OTSafeArray<OTAttribute *> *)fullAttributesWithAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

@end

NS_ASSUME_NONNULL_END
