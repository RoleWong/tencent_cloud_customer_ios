//
//  OTTracerProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/11/30.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef OTTracerProtocl_h
#define OTTracerProtocl_h

#import "OTInstrumentationLibraryInfo.h"
#import "OTSpan.h"
#import "OTClockProtocol.h"
#import "OTIdsGenerator.h"
#import "OTContextProtocol.h"
#import "OTSpanBizDecoratorProtocol.h"

@class OTTracerProvider;

typedef void (^OTSpanCreationBlock)(OTSpan *_Nullable span);

NS_ASSUME_NONNULL_BEGIN

@protocol OTTracerProtocol <NSObject>

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

/// create a span with span name, it will be configured as the subspan of the tracer's current active span
/// @param name name description
- (OTSpan *)spanWithName:(NSString *)name;

/// create a span with span name, it will be configured as the subspan of the tracer's current active span
/// @param name name description
/// @param bizDecorator biz custom span field
- (OTSpan *)spanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator;

/// create a span asynchronously
/// @param name name
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name completion:(OTSpanCreationBlock)completion;

/// create a span asynchronously
/// @param name name
/// @param bizDecorator biz custom span field
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name
             bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
               completion:(OTSpanCreationBlock)completion;

/// create a span with name and parent span, it will be configured as the subspan of the parent span
/// @param name name
/// @param parentSpan parent span
- (OTSpan *_Nullable)spanWithName:(NSString *)name parent:(OTSpan *)parentSpan;

/// create a span with name and parent span, it will be configured as the subspan of the parent span
/// @param name name
/// @param bizDecorator biz custom span field
/// @param parentSpan parent span
- (OTSpan *_Nullable)spanWithName:(NSString *)name
                     bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
                           parent:(OTSpan *)parentSpan;

/// create a span asynchronously
/// @param name span name
/// @param parentSpan parent span
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name parent:(OTSpan *)parentSpan completion:(OTSpanCreationBlock)completion;

/// create a span asynchronously
/// @param name span name
/// @param bizDecorator biz custom span field
/// @param parentSpan parent span
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name
             bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator
                   parent:(OTSpan *)parentSpan
               completion:(OTSpanCreationBlock)completion;

/// create a span with name and remote span's context
/// @param name span name
/// @param remoteSpanContext span context
- (OTSpan *)spanWithName:(NSString *)name context:(OTSpanContext *)remoteSpanContext;

/// create a span with name and remote span's context
/// @param name span name
/// @param bizDecorator biz custom span field
/// @param remoteSpanContext span context
- (OTSpan *)spanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator context:(OTSpanContext *)remoteSpanContext;

/// create a span asynchronously
/// @param name span name
/// @param remoteSpanContext parent span
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name context:(OTSpanContext *)remoteSpanContext completion:(OTSpanCreationBlock)completion;

/// create a span asynchronously
/// @param name span name
/// @param bizDecorator biz custom span field
/// @param remoteSpanContext parent span
/// @param completion callback when span is created
- (void)asyncSpanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator context:(OTSpanContext *)remoteSpanContext completion:(OTSpanCreationBlock)completion;

/// create a root span with name
/// @param name span name
- (OTSpan *_Nullable)rootSpanWithName:(NSString *)name;
/// create a root span with name
/// @param name span name
/// @param bizDecorator biz custom span field
- (OTSpan *)rootSpanWithName:(NSString *)name bizDecorator:(__nullable id<OTSpanBizDecoratorProtocol>)bizDecorator;

/// create a root span asynchronously with name
/// @param name span name
- (void)asyncRootSpanWithName:(NSString *)name completion:(OTSpanCreationBlock)completion;

/// mark target span as active for the tracer.
/// @param spanId spanId description
- (void)markActiveSpanId:(NSString *)spanId;

/// stash span in tracer, make sure its persistance until the span is ended
/// @param span span description
/// @param spanId spanId description
- (void)stashToContextWithSpan:(OTSpan *)span spanId:(NSString *)spanId;

/// remove a span when it's ended
/// @param spanId spanId description
- (void)removeFromContextWithSpan:(NSString *)spanId;

/// return current active span
- (OTSpan *)currentActiveSpan;

/// reutrn an span witch is not ended
/// @param spanId spanId description
- (OTSpan *)spanCachedBySpanId:(NSString *)spanId;

/// reutrn an span witch is not ended
/// @param spanContextString serialized spanContext string with w3c format
- (OTSpan *)spanCachedBySpanContextString:(NSString *)spanContextString;

/// reutrn an span witch is not ended
/// @param spanContext spanContext
- (OTSpan *)spanCachedBySpanContext:(id<OTContextProtocol>)spanContext;

@end

NS_ASSUME_NONNULL_END

#endif /* OTTracerProtocl_h */
