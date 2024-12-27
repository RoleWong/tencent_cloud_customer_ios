//
//  OTExemplarReservoirProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/11/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef OTExemplarReservoirProtocol_h
#define OTExemplarReservoirProtocol_h

#import "OTMeasurement.h"
#import "OTExemplar.h"
#import "OTExemplarFilterProtocol.h"
#import "OTContextProtocol.h"
#import "OTClockProtocol.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_SPAN
#import "OTTracerProvider.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// when an exemplar is about to create, Reservoir will call this block to acquire the trace context of the related measurement, and associate one to
/// the other
typedef id<OTContextProtocol> _Nullable (^OTOfferContextHandler)(OTMeasurement *mesurement);

@protocol OTExemplarReservoirProtocol <NSObject>

/// clock instance helps getting proper time stamp for the exemplar reservoir
@property (nonatomic, strong) id<OTClockProtocol> clock;

/// filter instance responsible for deciding wich measuremnt can convert to exemplar and attached to certain data points
@property (nonatomic, strong) id<OTExemplarFilterProtocol> filter;

#ifdef OT_TRACING_SDK_SPAN
/// if provided, the reservoir will collect trace context automatically from the tracerprovider
@property (nonatomic, strong) OTTracerProvider *tracerProvider;
#endif

/// User offer context to reservoir by this callback, helps exemplar associated to certain trace
@property (nonatomic, copy) OTOfferContextHandler offeredContextCallback;

/// Called by aggregator, filtered measurement will be send to reservoir, converted to exemplar and return
/// @param measurement filtered measurement
- (OTExemplar *_Nullable)exemplarConvertedFromMeasurement:(OTMeasurement *)measurement;

@end

NS_ASSUME_NONNULL_END

#endif /* OTExemplarReservoirProtocol_h */
