//
//  OTMeasurement.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMeasurement.h"
#import "OTAttributesWithCapacity.h"

@interface OTMeasurement ()

/// The name of the Instrument who created this measurement
@property (nonatomic, copy, readwrite) NSString *name;

/// An optional description of the Instrument who created this measurement
@property (nonatomic, copy, readwrite) NSString *descriptionInfo;

/// An optional unit of the Instrument who created this measurement
@property (nonatomic, copy, readwrite) NSString *unit;

@property (nonatomic, assign, readwrite) OTNumericValueType valueType;

@property (nonatomic, strong, readwrite) id<OTContextProtocol> context;

@property (nonatomic, strong, readwrite) OTSafeArray<OTAttribute *> *attributes;

@end

@implementation OTMeasurement

- (instancetype)initWithValue:(NSNumber *)value valueType:(OTNumericValueType)valueType attributes:(OTSafeArray<OTAttribute *> *)attributes {
    if (self = [super init]) {
        _value = value;
        _attributes = [[OTSafeArray alloc] init];
        [_attributes addObjectsFromArray:[attributes fetchArray]];
        _valueType = valueType;
    }
    return self;
}

- (NSString *)attributesKeyValuePairs {
    NSString *tempString = @"";
    NSMutableArray *tempKeyValueStrings = [[NSMutableArray alloc] init];
    [self.attributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [tempKeyValueStrings addObject:[obj keyValueString]];
    }];
    tempString = [tempKeyValueStrings componentsJoinedByString:@"_"];
    return tempString;
}

- (void)addAttributesWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    OTAttributesWithCapacity *dictionaryAttributes = [OTAttributesWithCapacity attributesCollectionWithDictionary:dictionary];
    if (!self.attributes) {
        self.attributes = [[OTSafeArray alloc] init];
    }
    [self.attributes addObjectsFromArray:dictionaryAttributes.attributes];
}

@end
