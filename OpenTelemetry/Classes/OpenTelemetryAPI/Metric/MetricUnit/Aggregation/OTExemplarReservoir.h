//
//  OTExemplarReservoir.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTExemplarReservoirProtocol.h"
#import "OTDependencyDefine.h"
#ifdef OT_TRACING_SDK_SPAN
#import "OTTracerProviderProtocol.h"
#import "OTTracer.h"
#import "OTSpan.h"
#import "OTSpanContext.h"
#endif

NS_ASSUME_NONNULL_BEGIN
/// when an exemplar is about to create, Reservoir will call this block to acquire the trace context of the related measurement, and associate one to
/// the other
@interface OTExemplarReservoir : NSObject <OTExemplarReservoirProtocol>

/// clock instance helps getting proper time stamp for the exemplar reservoir
@property (nonatomic, strong) id<OTClockProtocol> clock;

/// filter instance responsible for deciding wich measuremnt can convert to exemplar and attached to certain data points
@property (nonatomic, strong) id<OTExemplarFilterProtocol> filter;

#ifdef OT_TRACING_SDK_SPAN
/// if provided, the reservoir will collect trace context automatically from the tracerprovider
@property (nonatomic, strong) id<OTTracerProviderProtocol> tracerProvider;
#endif

/// User offer context to reservoir by this callback, helps the exemplar associated to certain trace
@property (nonatomic, copy) OTOfferContextHandler offeredContextCallback;

@end

NS_ASSUME_NONNULL_END
