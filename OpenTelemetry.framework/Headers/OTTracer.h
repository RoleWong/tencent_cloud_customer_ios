//
//  OTTracer.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/4/30.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTTracerProtocol.h"

@class OTTracerProvider;

NS_ASSUME_NONNULL_BEGIN

@interface OTTracer : NSObject <OTTracerProtocol, OTSpanDelegate>

/// Id generator instance is used to generate traceIDs & spanIDs for spans created by this tracer
@property (nonatomic, strong) id<OTIdsGenerator> idGenerator;

/// clock instance for spans to record start and end times.
@property (nonatomic, strong) id<OTClockProtocol> clock;

/// InstrumentationLibraryInfo inherit from tracer provider
@property (nonatomic, strong, readonly) OTInstrumentationLibraryInfo *instrumentationLibraryInfo;

/// Provider that created the tracer
@property (nonatomic, weak) OTTracerProvider *provider;

/// max attributes amount of the span which created by this tracer
@property (nonatomic, assign) NSInteger maxNumberOfAttributes;

/// max event amount of the span which created by this tracer
@property (nonatomic, assign) NSInteger maxNumberOfEvents;

/// max link amount of the span which created by this tracer
@property (nonatomic, assign) NSInteger maxNumberOfLinks;

/// max attributes amount for each event of the span which created by this tracer
@property (nonatomic, assign) NSInteger maxNumberOfAttributesPerEvent;

/// max attributes amount for each link of the span which created by this tracer
@property (nonatomic, assign) NSInteger maxNumberOfAttributesPerLink;

/// An active tracer will automatically mark its newly created span as active. This will affect the method currentActive span and span creation
/// methods.
@property (nonatomic, assign, getter=isActive) BOOL active;

- (instancetype)initWithInfo:(OTInstrumentationLibraryInfo *)instrumentationLibraryInfo;

@end

NS_ASSUME_NONNULL_END
