//
//  OTMeterProvider.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/7/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTMeterProvider.h"
#import "OTMeter.h"
#import "OTMetricReader.h"
#import "OTSafeDictionary.h"
#import "OTSafeArray.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTMetricExporter.h"
#import "OTResource.h"
#import "OTDependencyDefine.h"
#import "OTMetricDataSink.h"

@interface OTMeterProvider ()

/// cached Meters
@property (nonatomic, strong) OTSafeDictionary *meters;

/// cached Metric readers
@property (nonatomic, strong) OTSafeDictionary<NSString *, id<OTMetricReaderProtocol>> *readers;

/// Meteric views that registered under the meter provider
@property (nonatomic, strong) OTSafeArray<OTMetricView *> *registeredViews;

@end

@implementation OTMeterProvider

- (instancetype)initWithResource:(OTResource *)resource {
    if (self = [super init]) {
        _meters = [[OTSafeDictionary alloc] init];
        _readers = [[OTSafeDictionary alloc] init];
        _registeredViews = [[OTSafeArray alloc] init];
        _resource = resource;
        // default reader
        OTMetricReader *reader = [[OTMetricReader alloc] init];
        reader.readIntervalMillis = 10000;
        [self registerMetricReader:reader forKey:@"defaultReader"];
    }
    return self;
}

- (instancetype)init {
    return [self initWithResource:nil];
}

#pragma mark - Private

- (OTSafeArray<OTMetricDataSink *> *)collectMetricDataFromAllMeters {
    OTSafeDictionary *allMeters = self.meters;
    OTSafeDictionary<NSString *, OTMetricDataSink *> *metricDataSinksDict = [[OTSafeDictionary alloc] init];
    [allMeters enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, OTMeter *_Nonnull obj, BOOL *_Nonnull stop) {
        // iterate all libraryInfo from meters, add new libraryInfo if not cached in metricDatasDict
        OTMetricDataSink *sink = [metricDataSinksDict objectForKey:obj.libraryInfo.key];
        if (!sink) {
            sink = [[OTMetricDataSink alloc] init];
            sink.libraryInfo = obj.libraryInfo;
            [metricDataSinksDict setValue:sink forKey:obj.libraryInfo.key];
        }
        OTSafeArray *metricDatasFromMeter = [obj collectMetricDataFromAggregators];
        [sink.metricDatas addObjectsFromArray:[metricDatasFromMeter fetchArray]];
    }];
    // remove metric data with out any data points
    OTSafeArray *safeMetricDatas = [[OTSafeArray alloc] init];
    [metricDataSinksDict enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTMetricDataSink *_Nonnull obj, BOOL *_Nonnull stop) {
        if (obj.metricDatas.count > 0) {
            [safeMetricDatas addObject:obj];
        }
    }];
    return safeMetricDatas;
}

- (void)createNewDataPointsForAllMeters {
    [self.meters enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTMeter *_Nonnull obj, BOOL *_Nonnull stop) {
        [obj triggerObservableInstruments];
        [obj createNewDataPoint];
    }];
}

#pragma mark - Public
- (id<OTMeterProtocol>)meterWithName:(NSString *)name version:(NSString *)version schemaUrl:(NSString *)schemaUrl {
    OTMeter *meter = nil;
    OTInstrumentationLibraryInfo *info = [[OTInstrumentationLibraryInfo alloc] initWithName:name version:version];
    info.schemaUrl = schemaUrl;
    NSString *infoKey = info.key;
    meter = [self.meters objectForKey:infoKey];
    if (!meter) {
        meter = [[OTMeter alloc] initWithLibraryInfo:info];
        __weak typeof(self) weakSelf = self;
        meter.acquireMetricViewsHandler = ^OTSafeArray<OTMetricView *> *_Nullable {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            return strongSelf.registeredViews;
        };
        [self.meters setValue:meter forKey:infoKey];
    }
    return meter;
}

- (void)registerMetricReader:(id<OTMetricReaderProtocol>)metricReader forKey:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    metricReader.collectCallback = ^OTSafeArray<OTMetricDataSink *> * {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        OTSafeArray *metricDatas = [strongSelf collectMetricDataFromAllMeters];
        return metricDatas;
    };
    metricReader.onMetricDataRead = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf createNewDataPointsForAllMeters];
    };
    metricReader.resource = self.resource;
    [self.readers setObject:metricReader forKey:key];
}

- (void)removeMetricReaderForKey:(NSString *)key {
    [self.readers removeObjectForKey:key];
}

- (id<OTMetricReaderProtocol>)metricReaderForkey:(NSString *)key {
    return [self.readers objectForKey:key];
}

- (id<OTMetricReaderProtocol>)defaultMetricReader {
    return [self metricReaderForkey:@"defaultReader"];
}

- (void)shutdown {
    [self.readers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTMetricReaderProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        [obj shutdown];
    }];
}

- (void)forceFlush {
    [self.readers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTMetricReaderProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        [obj forceFlush];
    }];
}

- (BOOL)addView:(OTMetricView *)view error:(NSError *__autoreleasing _Nullable *)error {
    BOOL isValid = [view isValidMetricViewWithError:error];
    if (isValid) {
        [self.registeredViews addObject:view];
    }
    return isValid;
}

- (BOOL)addViewWithCriteria:(NSDictionary<OTCriteriaKey, id> *)criteria
                     params:(NSDictionary<OTMetricViewKey, id> *)params
                      error:(NSError *__autoreleasing _Nullable *)error {
    OTMetricView *view = [[OTMetricView alloc] initWithCriteria:criteria params:params];
    return [self addView:view error:error];
}

- (void)removeAllViews {
    [self.registeredViews removeAllObjects];
}

@end
