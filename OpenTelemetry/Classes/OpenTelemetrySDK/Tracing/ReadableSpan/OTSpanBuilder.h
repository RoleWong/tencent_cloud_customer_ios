//
//  OTSpanBuilder.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTDependencyDefine.h"
#import "OTIdsGenerator.h"
#import "OTTracer.h"
#import "OTResource.h"
#import "OTClock.h"
#import "OTSpan.h"
#import "OTSpanBizDecoratorProtocol.h"

@class OTInstrumentationLibraryInfo;

NS_ASSUME_NONNULL_BEGIN

/// the builder of spans
@interface OTSpanBuilder : NSObject

/// initialize a builder of the span
/// @param spanName name of the span
/// @param tracer trace that called the span's creation
- (instancetype)initWithSpanName:(NSString *)spanName tracer:(OTTracer *)tracer;

/// config the parent span of the creating span
/// @param parentSpan parent span
- (void)configParentSpan:(OTSpan *)parentSpan;

/// config the span as the tracer's current active span
- (void)configDefaultParent;

/// config the span's parent from a remote context
/// @param parentContext parent span context
- (void)configParentContext:(OTSpanContext *)parentContext;

/// config the id generator to create spanId and trace Id
/// @param idGenerator idGenerator description
- (void)configIdGenerator:(id<OTIdsGenerator>)idGenerator;

/// config a root span
- (void)configNoParent;

/// config the clock of span process
/// @param clock clock object
- (void)configClock:(id<OTClockProtocol>)clock;

/// biz assign custom field decorator,such as kind, startTime etc.
- (void)configBizDecorator:(id<OTSpanBizDecoratorProtocol>)bizDecorator;

/// create a span with current configuartion
- (OTSpan *)buildSpan;

@end

NS_ASSUME_NONNULL_END
