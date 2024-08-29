//
//  OTTracerProvider.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/3.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTDependencyDefine.h"
#import "OTSamplerProtocol.h"
#import "OTSpanProcessorProtocol.h"
#import "OTResource.h"
#import "OTTracerProtocol.h"

@class OTTracer;

NS_ASSUME_NONNULL_BEGIN

@protocol OTTracerProviderProtocol <NSObject>

/// to avoid memory issue spanInstancesLimit decide the maxium spans allowed per tracer. if reach this limit, there will be no new span created from
/// the tracer.
@property (nonatomic, assign) NSUInteger spanInstancesLimit;

/// get current tracer if availabel
@property (nonatomic, strong, readonly, nullable) id<OTTracerProtocol> currentTracer;

/// context for remote end to acquire trace info
@property (nonatomic, copy, readonly) NSString *traceBaggageSerializedString;

/// Common resource for trace
@property (nonatomic, strong) OTResource *resource;

/// add or replace a new processor with key
/// @param processor processor object
/// @param key key
- (void)registerSpanProcessor:(id<OTSpanProcessorProtocol>)processor forKey:(NSString *)key;

/// Get a processor with key
/// @param key key
- (id<OTSpanProcessorProtocol> _Nullable)spanProessorForKey:(NSString *)key;

/// Get default processor
- (id<OTSpanProcessorProtocol> _Nullable)defaultSpanProcessor;

/// removeb a processor with key
/// @param key key
- (void)removeSpanProcessorForKey:(NSString *)key;

/// shut down all telemetry
- (void)shutdown;

/// export all ended spans
- (void)forceFlush;

/// config an new sampler to replace the default sampler
/// @param sampler sampler
- (void)updateDefaultSpanSampler:(id<OTSamplerProtocol>)sampler;

/// register an new sampler worktogether with the default sampler
/// @param sampler sampler description
/// @param key key description
- (void)registerSampler:(id<OTSamplerProtocol>)sampler forKey:(NSString *)key;

/// get sampler with key
/// @param key key description
- (id<OTSamplerProtocol>)samplerForKey:(NSString *)key;

/// get default sampler
- (id<OTSamplerProtocol> _Nullable)defaultSampler;

/// remove sampler with key
/// @param key key description
- (void)removeSamplerForKey:(NSString *)key;

/// get all samplers
- (NSArray<id<OTSamplerProtocol>> *)samplerList;

/// create a tracer
/// @param name instriumentation library info
/// @param version version
- (id<OTTracerProtocol>)tracerWithInstrumentationName:(NSString *)name version:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
