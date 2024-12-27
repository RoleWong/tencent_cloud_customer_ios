//
//  OTInstrument.m
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/8/4.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrument.h"
#import "OTInstrument+Private.h"
#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"
#import "OTSafeArray.h"
#import "OTSafeDictionary.h"
#import "NSNumber+OTJsonTools.h"
#import "OTExemplar.h"
#import "OTDependencyDefine.h"
#ifdef OT_METRIC_SDK_INSTRUMENT
#import "OTAggregatorFactory.h"
#endif

@interface OTInstrument ()

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

@property (nonatomic, strong) OTAttributesWithCapacity *attributesCache;

@end

@implementation OTInstrument

- (instancetype)init {
    if (self = [super init]) {
        _attributesCache = [[OTAttributesWithCapacity alloc] initWithCapacity:128];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter & Setter

- (NSArray<OTAttribute *> *)attributes {
    return [self.attributesCache attributes];
}

#pragma mark - Public

- (OTAttribute *)attributeForKey:(NSString *)key {
    return [_attributesCache attributeForKey:key];
}

- (void)updateAttributeValue:(NSString *)value forKey:(NSString *)key {
    OTAttribute *attri = [OTAttribute attributeWithKey:key stringValue:value];
    [_attributesCache updateAttribute:attri];
}

- (void)updateAttributeValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    OTAttribute *attri = [OTAttribute attributeWithKey:key values:values];
    [_attributesCache updateAttribute:attri];
}

- (void)updateAttribute:(OTAttribute *)attribute {
    [_attributesCache updateAttribute:attribute];
}

- (void)updateAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
    OTAttributesWithCapacity *attriCollection = [OTAttributesWithCapacity attributesCollectionWithDictionary:attributes];
    [_attributesCache updateAttributes:attriCollection.attributes];
}

- (void)updateAttributesArray:(NSArray<OTAttribute *> *)attributes {
    [_attributesCache updateAttributes:attributes];
}

- (OTSafeArray<OTAttribute *> *)fullAttributesWithAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
    OTAttributesWithCapacity *dataPointAttributes = [OTAttributesWithCapacity attributesCollectionWithDictionary:attributes];
    NSMutableArray *fullAttributes = [[NSMutableArray alloc] initWithArray:self.attributes];
    [fullAttributes addObjectsFromArray:dataPointAttributes.attributes];
    return [[OTSafeArray alloc] initWithNSMutableArray:fullAttributes];
}

@end
