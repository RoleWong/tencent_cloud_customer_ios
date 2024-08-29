//
//  OTSpan.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/4/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"
#import "OTSpanKind.h"
#import "OTStatusCanonicalCode.h"
#import "OTJsonConvertible.h"
#import "OTContextProtocol.h"

@class OTEvent, OTSpanContext, OTStatus, OTAttribute, OTLink, OTSpan, OTInstrumentationLibraryInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol OTSpanDelegate <NSObject>

/// This delegate method called when a span is about to start.
/// @param span starting span
/// @param spanId starting span's id
- (void)span:(OTSpan *)span didStartedWithSpanId:(NSString *)spanId;

/// This delegate method called when a span is about to end.
/// @param span ending span
/// @param spanId ending span's id
- (void)span:(OTSpan *)span didEndedWithSpanId:(NSString *)spanId;

/// return super span of a span
/// @param span span
- (OTSpan *_Nullable)parentSpanForSpan:(OTSpan *)span;

@end

@interface OTSpan : OTBaseObject <OTJsonConvertible>

/// inrumentation info from tracer
@property (nonatomic, strong, readonly) OTInstrumentationLibraryInfo *libraryInfo;

/// Type of the span , see SpanKind.h
@property (nonatomic, copy, readonly) OTSpanKind kind;

/// SpanContext containts the information to identify the span, such as spanId, traceId
@property (nonatomic, strong, readonly) OTSpanContext *context;

/// The super span context in the same trace
@property (nonatomic, strong, readonly) OTSpanContext *parentSpanContext;

/// the super span in the same trace if exist
@property (nonatomic, strong, readonly, nullable) OTSpan *parentSpanIfNotEnded;

/// Indicate that the span is ended or not
@property (nonatomic, assign, getter=isRecording, readonly) BOOL recording;

/// States wethere the span is end normally, see OTStatusCanonicalCode.h
@property (nonatomic, assign, readonly) OTStatusCanonicalCode status;

/// A developer-facing human readable error message.
@property (nonatomic, copy) NSString *statusMessage;

/// Span name
@property (nonatomic, copy, readonly) NSString *name;

/// Recorded events during the span's life period
@property (nonatomic, copy, readonly) NSArray<OTEvent *> *events;

/// Attritbutes of the span
@property (nonatomic, copy, readonly) NSArray<OTAttribute *> *attributes;

/// Link that refers to span in another trace
@property (nonatomic, copy, readonly) NSArray<OTLink *> *links;

/// to tell the tracer wether this span will ended recursively
@property (nonatomic, assign, readonly, getter=isEndedRecursively) BOOL endedRecursively;

#pragma mark - Configure span attribute

/// get an attribute value from the span
/// @param key attribute's key
- (OTAttribute *)attributeForKey:(NSString *)key;

/// Add or replace the attribute value of the span
/// @param value new value
/// @param key attribute key
- (void)updateAttributeValue:(NSString *)value forKey:(NSString *)key;

/// Add or replace the attribute value of the span with an string array
/// @param values values represent as a stirng array
/// @param key attribute key
- (void)updateAttributeValues:(NSArray<NSString *> *)values forKey:(NSString *)key;

/// Add or replace an attribute
/// @param attribute attribute
- (void)updateAttribute:(OTAttribute *)attribute;

/// Add or replace the attribute value of the span with an dictionary
/// @param attributes attribute represent as dictionary
- (void)updateAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

/// Add or replace attributes
/// @param attributes attributes
- (void)updateAttributesArray:(NSArray<OTAttribute *> *)attributes;

#pragma mark - Add links

///  add a link to the span
/// @param link link description
- (void)addLink:(OTLink *)link;

/// add sevral links to the span
/// @param links links description
- (void)addLinks:(NSArray<OTLink *> *)links;

/// generate link with span context and add it to current span
/// @param context context description
- (void)addLinkWithContext:(id<OTContextProtocol>)context;

/// generate link with span context and attributes, then add it to current span
/// @param context context description
/// @param attributes attributes description
- (void)addLinkWithContext:(id<OTContextProtocol>)context attributes:(NSDictionary<NSString *, id> *)attributes;

#pragma mark - Add events

- (void)addEvent:(OTEvent *)event;

- (void)addEvents:(NSArray<OTEvent *> *)events;

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes timeStamp:(int64_t)timeStamp;

- (void)addEventWithName:(NSString *)name timeStamp:(int64_t)timeStamp;

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes;

- (void)addEventWithName:(NSString *)name;

#pragma mark - start span

/// start a span
- (void)startSpan;
/// start a span
/// @param timestamp timestamp
- (void)startSpanWithTimestamp:(NSTimeInterval)timestamp;

#pragma mark - End span

/// end the span immedately
- (void)end;

/// end current span as well as its super span, repeat this process until there is no parent span instance.
- (void)endRecursively;

/// end the span with a status
/// @param status status code
- (void)endWithStatus:(OTStatusCanonicalCode)status;

/// end specific span with given time stamp in NANO SECOND format
/// @param status status code
/// @param timestamp timestamp
- (void)endWithStatus:(OTStatusCanonicalCode)status timestamp:(NSTimeInterval)timestamp;

@end

NS_ASSUME_NONNULL_END
