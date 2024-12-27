//
//  OTInstrumentBuilder.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrumentBuilder.h"

#import "OTCounter.h"
#import "OTObservableCounter.h"
#import "OTObservableUpDownCounter.h"
#import "OTUpDownCounter.h"
#import "OTHistogram.h"
#import "OTObservableGauge.h"
#import "NSNumber+OTJsonTools.h"
#import "OTInstrument+Private.h"
#import "OTSafeDictionary.h"

@interface OTInstrumentBuilder ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *typeToClassNameMapping;

@property (nonatomic, assign) OTInstrumentType type;
@property (nonatomic, assign) OTNumericValueType valueType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *descriptionInfo;

@end

@implementation OTInstrumentBuilder

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Getter & Setter

- (NSDictionary<NSString *, NSString *> *)typeToClassNameMapping {
    if (!_typeToClassNameMapping) {
        NSMutableDictionary *typeToClassDict = [[NSMutableDictionary alloc] init];
        [typeToClassDict setObject:NSStringFromClass([OTCounter class]) forKey:@(OTInstrumentTypeCounter).ot_toIntegerString];
        [typeToClassDict setObject:NSStringFromClass([OTObservableCounter class]) forKey:@(OTInstrumentTypeObservableCounter).ot_toIntegerString];
        [typeToClassDict setObject:NSStringFromClass([OTUpDownCounter class]) forKey:@(OTInstrumentTypeUpDownCounter).ot_toIntegerString];
        [typeToClassDict setObject:NSStringFromClass([OTObservableUpDownCounter class])
                            forKey:@(OTInstrumentTypeObservalbleUpDownCounter).ot_toIntegerString];
        [typeToClassDict setObject:NSStringFromClass([OTHistogram class]) forKey:@(OTInstrumentTypeHistogram).ot_toIntegerString];
        [typeToClassDict setObject:NSStringFromClass([OTObservableGauge class]) forKey:@(OTInstrumentTypeObservableGauge).ot_toIntegerString];
        _typeToClassNameMapping = typeToClassDict;
    }
    return _typeToClassNameMapping;
}

#pragma mark - Public

- (OTInstrumentBuilder *)configType:(OTInstrumentType)type {
    self.type = type;
    return self;
}

- (OTInstrumentBuilder *)configValueType:(OTNumericValueType)valueType {
    self.valueType = valueType;
    return self;
}

- (OTInstrumentBuilder *)configName:(NSString *)name {
    self.name = name;
    return self;
}

- (OTInstrumentBuilder *)configUnit:(NSString *)unit {
    self.unit = unit;
    return self;
}

- (OTInstrumentBuilder *)configDescription:(NSString *)description {
    self.descriptionInfo = description;
    return self;
}

- (OTInstrument *)build {
    NSString *className = [self.typeToClassNameMapping objectForKey:@(self.type).ot_toIntegerString];
    OTInstrument *instrument = nil;
    if (className.length > 0) {
        instrument = [[NSClassFromString(className) alloc] init];
        instrument.valueType = self.valueType;
        instrument.name = self.name;
        instrument.unit = self.unit;
        instrument.descriptionInfo = self.descriptionInfo;
    }
    return instrument;
}

@end
