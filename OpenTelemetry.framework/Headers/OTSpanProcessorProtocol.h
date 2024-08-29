//
//  OTSpanProcessorProtocol.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTCallbackDefine.h"
#import "OTSpanExporterProtocol.h"

@class OTResource, OTSpan;

NS_ASSUME_NONNULL_BEGIN

typedef void (^OTSpanStartedBlock)(OTSpan *span);
typedef void (^OTSpanEndedBlock)(OTSpan *span);

@protocol OTSpanProcessorProtocol <NSObject>

/// resource of the provider it was registered
@property (nonatomic, strong) OTResource *resource;

/// this block will called when processor is calling onStart method
@property (nonatomic, copy, nullable) OTSpanStartedBlock onSpanStartedCallback;

/// this block will called when processor has sent a bunch of spans
@property (nonatomic, copy, nullable) OTExporterCallback onSpanReportedCallback;

/// this block will be called when processor is calling onEnd method
@property (nonatomic, copy) OTSpanEndedBlock onSpanEndedCallback;

/// maximum number of spans the processor can handle, over this limit, the span will be ignore.
@property (nonatomic, assign) NSUInteger maxQueueSize;

/// export span export interval, counter in milliseconds
@property (nonatomic, assign) NSTimeInterval processInterval;

/// maximum number of spans per exportation.
@property (nonatomic, assign) NSUInteger maxExportBatchSize;

/// exporter of the span
@property (nonatomic, strong) id<OTSpanExporterProtocol> exporter;

/// called when a span is about to start
/// @param span span description
- (void)onStart:(OTSpan *)span;

/// called when a span is about to end
/// @param span span description
- (void)onEnd:(OTSpan *)span;

/// when shutdown is called by it's provider, the processor must shutdown
- (void)shutdown;

/// when force flush is called by it's provider, the processor must forceflush all span data
- (void)forceFlush;

@end

NS_ASSUME_NONNULL_END
