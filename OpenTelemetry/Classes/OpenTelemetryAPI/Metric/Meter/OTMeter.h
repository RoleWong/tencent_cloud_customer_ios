//
//  OTMeter.h
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMeterProtocol.h"

@class OTInstrumentationLibraryInfo, OTCounter;

NS_ASSUME_NONNULL_BEGIN

@interface OTMeter : NSObject <OTMeterProtocol>

@property (nonatomic, strong, readonly) OTInstrumentationLibraryInfo *libraryInfo;

/// Meter will call this block to acquire metric views registered under its provider
@property (nonatomic, copy) OTProviderMetricViewsHandler acquireMetricViewsHandler;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithLibraryInfo:(OTInstrumentationLibraryInfo *)info NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
