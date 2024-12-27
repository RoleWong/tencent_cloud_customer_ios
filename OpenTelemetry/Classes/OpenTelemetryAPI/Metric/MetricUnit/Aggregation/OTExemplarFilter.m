//
//  OTExemplarFilter.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTExemplarFilter.h"
#import "OTMeasurement.h"
#import "OTAttribute.h"

@interface OTExemplarFilter ()

@end

@implementation OTExemplarFilter

- (instancetype)init {
    if (self = [super init]) {
        _maxExemplarsForEachDataPoint = 1;
    }
    return self;
}

#pragma mark - Private

- (BOOL)hasMatchFilterAttributes:(OTMeasurement *)measurement {
    if (self.attributes.count == 0 || measurement.attributes.count == 0) {
        return NO;
    }
    __block BOOL filterRet = NO;
    [measurement.attributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        for (OTAttribute *filterAttribute in self.attributes) {
            if ([filterAttribute isEqual:obj]) {
                filterRet = YES;
                return;
            }
        }
    }];
    return filterRet;
}

/// Return if param measurement match the filters attribtue keys
/// @param measurement measurement collected by aggregator
- (BOOL)hasMatchFilterAttributeKeys:(OTMeasurement *)measurement {
    if (self.attrributeKeys.count == 0 || measurement.attributes.count == 0) {
        return NO;
    }
    __block BOOL filterRet = NO;
    [measurement.attributes enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        for (NSString *filterKey in self.attrributeKeys) {
            if ([filterKey isEqualToString:obj.key]) {
                filterRet = YES;
                return;
            }
        }
    }];
    return filterRet;
}

/// return if param measurement should sampled
/// @param measurement measurement collected by aggregator
- (BOOL)filterResultWithCallbackHandler:(OTMeasurement *)measurement {
    BOOL filterRet = NO;
    if (self.filterResultCallback) {
        filterRet = self.filterResultCallback(measurement);
    }
    return filterRet;
}

#pragma mark - Public

- (BOOL)shouldSampleMeasurement:(OTMeasurement *)measurement {
    switch (self.mode) {
        case OTExemplarFilterModeNone:
            return NO;

        case OTExemplarFilterModeAll:
            return YES;

        case OTExemplarFilterModeByAttributeKeys:
            return [self hasMatchFilterAttributeKeys:measurement];

        case OTExemplarFilterModeByHandlerFilterResultCallback:
            return [self filterResultWithCallbackHandler:measurement];

        case OTExemplarFilterModeByAttributes:
            return [self hasMatchFilterAttributes:measurement];
    }
}

@end
