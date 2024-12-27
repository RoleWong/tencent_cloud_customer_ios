//
//  OTMeasurement.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTValueTypeDefine.h"
#import "OTContextProtocol.h"
#import "OTAttribute.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

/// measurment was create by instrument, different types of insturment have their own way of creating measurement
@interface OTMeasurement : NSObject

/// The name of the Instrument who created this measurement
@property (nonatomic, copy, readonly) NSString *name;

/// An optional description of the Instrument who created this measurement
@property (nonatomic, copy, readonly) NSString *descriptionInfo;

/// An optional unit of the Instrument who created this measurement
@property (nonatomic, copy, readonly) NSString *unit;

/// value of the measurement
@property (nonatomic, copy) NSNumber *value;

/// value type of the value
@property (nonatomic, assign, readonly) OTNumericValueType valueType;

/// attributes of the value
@property (nonatomic, strong, readonly) OTSafeArray<OTAttribute *> *attributes;

/// a string that include all attributes of the measurement
@property (nonatomic, copy, readonly) NSString *attributesKeyValuePairs;

/// initialize a measurement instance
/// @param value the value of the measurement, required
/// @param valueType determin wether the value type is double or long;
/// @param attributes the attributes of measurement, optional
- (instancetype)initWithValue:(NSNumber *)value valueType:(OTNumericValueType)valueType attributes:(OTSafeArray<OTAttribute *> *_Nullable)attributes;

- (instancetype)init NS_UNAVAILABLE;

/// update attributes for a measurement
/// @param dictionary dictionary description
- (void)addAttributesWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

@end

NS_ASSUME_NONNULL_END
