//
//  OTTracerProvider.h
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2020/8/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTTracerProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const gInstrumentationLibraryName;

FOUNDATION_EXTERN NSString *const gOpenTelemeteryVersion;

/// Opentelemetry function API
@interface OTTracerProvider : NSObject <OTTracerProviderProtocol>

/// Resources carried from provider
@property (nonatomic, strong) OTResource *resource;

/// initialize instance with resource
/// @param resource resource
- (instancetype)initWithResource:(OTResource *_Nullable)resource;

/// initialize instance without resource
- (instancetype)init;

/// Called when a span was started
/// @param span span
- (void)onStart:(OTSpan *)span;

/// Called when a span was ended
/// @param span span
- (void)onEnd:(OTSpan *)span;

@end

NS_ASSUME_NONNULL_END
