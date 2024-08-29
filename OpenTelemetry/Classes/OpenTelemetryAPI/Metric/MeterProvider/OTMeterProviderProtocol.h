//
//  OTMeterProviderProtocol.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/7/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMeterProtocol.h"
#import "OTStatusCanonicalCode.h"
#import "OTInstrument.h"
#import "OTAggregatorProtocol.h"
#import "OTMetricView.h"
#import "OTMetricReader.h"

@class OTMeter, OTInstrumentationLibraryInfo, OTResource;

NS_ASSUME_NONNULL_BEGIN
/// instance which confrom this protocl is responsible for creating meters
@protocol OTMeterProviderProtocol <NSObject>

@required

/// Common resource for metric
@property (nonatomic, strong) OTResource *resource;

/// generate a meter
/// @param name name of the instrumentationLibrary
/// @param version version of the instrumentationLibrary
/// @param schemaUrl schemeUrl description
- (id<OTMeterProtocol> _Nonnull)meterWithName:(NSString *)name version:(NSString *_Nullable)version schemaUrl:(NSString *_Nullable)schemaUrl;

/// immediate export all metric data stashed in the meters provided by this provider;
- (void)forceFlush;

/// shut down all meter provided by this provider, meter only generate unreadable instrument after shutted down
- (void)shutdown;

/// Add a view to help collect metric data
/// @param error an error will thrown if the value did'nt match the key's requirement
- (BOOL)addViewWithCriteria:(NSDictionary<OTCriteriaKey, id> *)criteria
                     params:(NSDictionary<OTMetricViewKey, id> *)params
                      error:(NSError **_Nullable)error;

/// remove all views from this meter provider, it works as default setting
- (void)removeAllViews;

#pragma mark - MetricReader

/// register an new metric reader
/// @param metricReader metricReader
/// @param key key
- (void)registerMetricReader:(id<OTMetricReaderProtocol>)metricReader forKey:(NSString *)key;

/// remove registered metric reader
/// @param key key description
- (void)removeMetricReaderForKey:(NSString *)key;

/// get metric reader for key
/// @param key key description
- (id<OTMetricReaderProtocol> _Nullable)metricReaderForkey:(NSString *)key;

/// get default metric reader
- (id<OTMetricReaderProtocol> _Nullable)defaultMetricReader;

NS_ASSUME_NONNULL_END

@end
