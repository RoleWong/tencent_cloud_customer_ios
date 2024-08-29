//
//  OTMeterProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef OTMeterProtocol_h
#define OTMeterProtocol_h

#import "OTInstrument.h"
#import "OTMetricView.h"
#import "OTInstrumentationLibraryInfo.h"

@class OTCounter, OTUpDownCounter, OTMetricDataPoint, OTObservableCounter, OTObservableGauge, OTObservableUpDownCounter, OTHistogram;

NS_ASSUME_NONNULL_BEGIN

typedef OTSafeArray<OTMetricView *> *_Nullable (^OTProviderMetricViewsHandler)(void);

/// instances which confrom this protocol are responsible for creating instruments
@protocol OTMeterProtocol <NSObject>

@required

/// insturmentation library's info that using this sdk
@property (nonatomic, strong, readonly) OTInstrumentationLibraryInfo *libraryInfo;

/// Meter will call this block to acquire metric views registered under its provider
@property (nonatomic, copy) OTProviderMetricViewsHandler acquireMetricViewsHandler;

#pragma mark - Counter

/// create a counter data type long, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
- (OTCounter *_Nullable)createCounter:(NSString *)name unit:(NSString *_Nullable)unit description:(NSString *_Nullable)description;

/// create a counter data type double, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
- (OTCounter *_Nullable)createDoubleCounter:(NSString *)name unit:(NSString *_Nullable)unit description:(NSString *_Nullable)description;

#pragma mark - UpDownCounter

/// create a updown counter data type long, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
- (OTUpDownCounter *_Nullable)createUpdownCounter:(NSString *)name unit:(NSString *_Nullable)unit description:(NSString *_Nullable)description;

/// create a updown counter data type double, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
- (OTUpDownCounter *_Nullable)createUpdownDoubleCounter:(NSString *)name unit:(NSString *_Nullable)unit description:(NSString *_Nullable)description;

#pragma mark - ObserverableCounter

/// create a observable counter data type long, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
/// @param onCollect called when the metric is collected, user should return the value
- (OTObservableCounter *_Nullable)createObservableCounter:(NSString *)name
                                                     unit:(NSString *_Nullable)unit
                                              description:(NSString *_Nullable)description
                                                onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a observable counter data type double, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
/// @param onCollect called when the metric is collected, user should return the double value
- (OTObservableCounter *_Nullable)createObservableDoubleCounter:(NSString *)name
                                                           unit:(NSString *_Nullable)unit
                                                    description:(NSString *_Nullable)description
                                                      onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a observable updown counter data type double, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
/// @param onCollect called when the metric is collected, user should return the value
- (OTObservableUpDownCounter *_Nullable)createObservableUpDownCounter:(NSString *)name
                                                                 unit:(NSString *_Nullable)unit
                                                          description:(NSString *_Nullable)description
                                                            onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a observable updown counter data type double, return nil if the same name was registered
/// @param name name of the counter
/// @param unit unit of the counter
/// @param description description of the counter
/// @param onCollect called when the metric is collected, user should return the double value
- (OTObservableUpDownCounter *_Nullable)createObservableUpDownDoubleCounter:(NSString *)name
                                                                       unit:(NSString *_Nullable)unit
                                                                description:(NSString *_Nullable)description
                                                                  onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a observable gauge data type long, return nil if the same name was registered
/// @param name name of the gauge
/// @param unit unit of the gauge
/// @param description description of the gauge
/// @param onCollect called when the metric is collected, user should return the long value
- (OTObservableGauge *_Nullable)createObservableGauge:(NSString *)name
                                                 unit:(NSString *_Nullable)unit
                                          description:(NSString *_Nullable)description
                                            onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a observable gauge data type double, return nil if the same name was registered
/// @param name name of the gauge
/// @param unit unit of the gauge
/// @param description description of the gauge
/// @param onCollect called when the metric is collected, user should return the double value
- (OTObservableGauge *_Nullable)createObservableDoubleGauge:(NSString *)name
                                                       unit:(NSString *_Nullable)unit
                                                description:(NSString *_Nullable)description
                                                  onCollect:(OTObservableMeasurementBlock)onCollect;

/// create a histogram, return nil if the same name was registerered
/// @param name name of the histogram
/// @param unit unit of the histogram
/// @param description description of the histogram
/// @param buckets to collect value for histogram, ie: a @[@5, @10] bucket can collect value between [5, 10)
- (OTHistogram *_Nullable)createHistogram:(NSString *)name
                                     unit:(NSString *_Nullable)unit
                              description:(NSString *_Nullable)description
                                  buckets:(NSArray<NSNumber *> *)buckets;

/// create a histogram, return nil if the same name was registerered
/// @param name name of the histogram
/// @param unit unit of the histogram
/// @param description description of the histogram
/// @param buckets to collect value for histogram, ie: a @[@5, @10] bucket can collect value between [5, 10)
- (OTHistogram *_Nullable)createDoubleHistogram:(NSString *)name
                                           unit:(NSString *_Nullable)unit
                                    description:(NSString *_Nullable)description
                                        buckets:(NSArray<NSNumber *> *)buckets;

#pragma mark - Common

/// return a registered Instrument
/// @param name name of the instrument
/// @param type type of the instrument
- (OTInstrument *_Nullable)registeredInstrumentWithName:(NSString *)name type:(OTInstrumentType)type;

/// remove a registered Instrument from cache
/// @param name name of the instrument
/// @param type type of the instrument
- (void)removeRegisteredInstrumentWithName:(NSString *)name type:(OTInstrumentType)type;

/// this method was to inform all the instruments created by this meter to collect a new data point
- (void)createNewDataPoint;

/// this method is used in creating metric datas to report to metric readers
- (OTSafeArray<OTMetricData *> *)collectMetricDataFromAggregators;

/// meter call this method to make all observable instruments take action to record a new measurement
- (void)triggerObservableInstruments;

@end

NS_ASSUME_NONNULL_END

#endif /* OTMeterProtocol_h */
