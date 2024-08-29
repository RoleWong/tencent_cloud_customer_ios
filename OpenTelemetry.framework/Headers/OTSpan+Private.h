//
//  OTSpan+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpan.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSpan (Private)

@property (nonatomic, weak) id<OTSpanDelegate> delegate;

@property (nonatomic, strong) OTInstrumentationLibraryInfo *libraryInfo;

/// Span name
@property (nonatomic, copy) NSString *name;

/// States wethere the span is end normally, see OTStatusCanonicalCode.h
@property (nonatomic, assign) OTStatusCanonicalCode status;

/// Type of the span , see SpanKind.h
@property (nonatomic, copy) OTSpanKind kind;

/// SpanContext containts the information to identify the span, such as spanId, traceId
@property (nonatomic, strong) OTSpanContext *context;

/// The super span context in the same trace
@property (nonatomic, strong) OTSpanContext *parentSpanContext;

/// to tell the tracer wether this span will ended recursively
@property (nonatomic, assign) BOOL endedRecursively;

/// Indicate that the span is ended or not
@property (nonatomic, assign) BOOL recording;

@end

NS_ASSUME_NONNULL_END
