//
//  OTMetricView.m
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTMetricView.h"
#import "OTMeasurement.h"
#import "OTInstrumentationLibraryInfo.h"

#pragma mark - Instrument selection criteria
OTCriteriaKey const OTCriteriaKeyInsrumentName = @"OTCriteriaKeyInsrumentName";
OTCriteriaKey const OTCriteriaKeyMeterName = @"OTCriteriaKeyMeterName";
OTCriteriaKey const OTCriteriaKeyMeterVersion = @"OTCriteriaKeyMeterVersion";
OTCriteriaKey const OTCriteriaKeyMeterSchemaURL = @"OTCriteriaKeyMeterSchemaURL";
OTCriteriaKey const OTCriteriaKeyAny = @"OTCriteriaKeyAny";

#pragma mark - Instrument Configuration
OTMetricViewKey const OTMetricViewKeyName = @"OTMetricViewKeyName";
OTMetricViewKey const OTMetricViewKeyDescription = @"OTMetricViewKeyDescription";
OTMetricViewKey const OTMetricViewKeyAttributeKeys = @"OTMetricViewKeyAttributeKeys";
OTMetricViewKey const OTMetricViewKeyAggregator = @"OTMetricViewKeyAggregator";
OTMetricViewKey const OTMetricViewKeyExemplarReservoir = @"OTMetricViewKeyExemplarReservoir";

NSNotificationName const OTMetricViewErrorDomain = @"OTMetricViewErrorDomain";

@interface OTMetricView ()

@property (nonatomic, copy, readwrite) OTSafeDictionary<OTCriteriaKey, id> *criteria;
@property (nonatomic, copy, readwrite) OTSafeDictionary<OTMetricViewKey, id> *params;

@end

@implementation OTMetricView

- (instancetype)initWithCriteria:(NSDictionary<OTCriteriaKey, id> *)criteria params:(NSDictionary<OTMetricViewKey, id> *)params {
    if (self = [super init]) {
        NSMutableDictionary *mutableCriteria = [[NSMutableDictionary alloc] initWithDictionary:criteria];
        NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithDictionary:params];
        _criteria = [[OTSafeDictionary alloc] initWithMutableDictionary:mutableCriteria];
        _params = [[OTSafeDictionary alloc] initWithMutableDictionary:mutableParams];
    }
    return self;
}

- (BOOL)isValidMetricViewWithError:(NSError *__autoreleasing _Nullable *)error {
    if (self.criteria.count == 0) {
        if (error) {
            *error = [NSError errorWithDomain:OTMetricViewErrorDomain
                                         code:OTMetricViewErrorStatusNoCriteria
                                     userInfo:@{ NSLocalizedDescriptionKey : @"Metetic view cratieria must contain at least one key-value pair" }];
        }
        return NO;
    }
    return YES;
}

- (BOOL)isMatchedWithMeasurement:(OTMeasurement *)measurement libraryInfo:(OTInstrumentationLibraryInfo *)libraryInfo {
    BOOL isMatched = NO;
    // when there is no criteria, metric view configuration will not apply to any measurement
    if (self.criteria.count == 0) {
        return isMatched;
    }
    // when criteria has a OTCriteriaKeyAny, means that all measuremnt passed by instrument under same provider will apply this metricview's
    // configuration.
    isMatched = [self.criteria objectForKey:OTCriteriaKeyAny] != nil;
    if (isMatched) {
        return isMatched;
    }
    // when criteria completely match a measurement, this measurement will applied metricview's configuration
    __block NSUInteger matchedCount = 0;
    [self.criteria enumerateKeysAndObjectsUsingBlock:^(OTCriteriaKey _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        if ([key isEqualToString:OTCriteriaKeyMeterName]) {
            matchedCount += [libraryInfo.name isEqualToString:(NSString *)obj] ? 1 : 0;
        } else if ([key isEqualToString:OTCriteriaKeyMeterVersion]) {
            matchedCount += [libraryInfo.version isEqualToString:(NSString *)obj] ? 1 : 0;
        } else if ([key isEqualToString:OTCriteriaKeyMeterSchemaURL]) {
            matchedCount += [libraryInfo.schemaUrl isEqualToString:(NSString *)obj] ? 1 : 0;
        } else if ([key isEqualToString:OTCriteriaKeyInsrumentName]) {
            matchedCount += [measurement.name isEqualToString:(NSString *)obj] ? 1 : 0;
        }
    }];
    isMatched = matchedCount == self.criteria.count;
    return isMatched;
}

@end
