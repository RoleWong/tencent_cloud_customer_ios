//
//  OTSpan.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/4/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpan.h"

#import "OTEvent.h"
#import "OTLink.h"
#import "OTSpanContext.h"

@interface OTSpan ()

/// to tell the tracer wether this span will ended recursively
@property (nonatomic, assign) BOOL endedRecursively;

/// inrumentation info from tracer
@property (nonatomic, strong) OTInstrumentationLibraryInfo *libraryInfo;

/// Type of the span , see SpanKind.h
@property (nonatomic, copy) OTSpanKind kind;

/// SpanContext containts the information to identify the span, such as spanId, traceId
@property (nonatomic, strong) OTSpanContext *context;

/// The super span context in the same trace
@property (nonatomic, strong) OTSpanContext *parentSpanContext;

@property (nonatomic, assign) BOOL recording;

/// States wethere the span is end normally, see OTStatusCanonicalCode.h
@property (nonatomic, assign) OTStatusCanonicalCode status;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSRecursiveLock *aliveStateLock;

@end

@implementation OTSpan

@synthesize recording = _recording;
@synthesize endedRecursively = _endedRecursively;

- (instancetype)init {
    if (self = [super init]) {
        _aliveStateLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return NO;
}

#pragma mark - End

- (void)startSpan {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)startSpanWithTimestamp:(NSTimeInterval)timestamp {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)end {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)endRecursively {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)endWithStatus:(OTStatusCanonicalCode)status {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)endWithStatus:(OTStatusCanonicalCode)status timestamp:(NSTimeInterval)timestamp {
    // abstruct class, should be impolemented in subclass.
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

#pragma mark - Attributes

- (OTAttribute *)attributeForKey:(NSString *)key {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
    return nil;
}

- (void)updateAttributeValue:(NSObject *)value forKey:(NSString *)key {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)updateAttributeValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)updateAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)updateAttributesArray:(NSArray<OTAttribute *> *)attributes {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)updateAttribute:(OTAttribute *)attribute {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

#pragma mark - Links

- (void)addLink:(OTLink *)link {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addLinks:(NSArray<OTLink *> *)links {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addLinkWithContext:(id<OTContextProtocol>)context attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addLinkWithContext:(id<OTContextProtocol>)context {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

#pragma mark - Events

- (void)addEvents:(NSArray<OTEvent *> *)events {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addEvent:(OTEvent *)event {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes timeStamp:(int64_t)timeStamp {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addEventWithName:(NSString *)name timeStamp:(int64_t)timeStamp {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (void)addEventWithName:(NSString *)name {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
}

- (NSDictionary *)toJson {
    NSAssert(NO, @"This is an abstract class, method %s must be implentment in subclass", __FUNCTION__);
    return @{};
}

- (void)setName:(NSString *)name {
    if (!self.isRecording) {
        return;
    }
    _name = name;
}

- (void)setStatus:(OTStatusCanonicalCode)status {
    if (!self.isRecording) {
        return;
    }
    _status = status;
}

- (void)setStatusMessage:(NSString *)statusMessage {
    if (!self.isRecording) {
        return;
    }
    _statusMessage = statusMessage;
}

- (OTSpan *)parentSpanIfNotEnded {
    return nil;
}

- (BOOL)isEndedRecursively {
    BOOL isEndedRecursively = NO;
    [self.aliveStateLock lock];
    isEndedRecursively = _endedRecursively;
    [self.aliveStateLock unlock];
    return isEndedRecursively;
}

- (void)setEndedRecursively:(BOOL)endedRecursively {
    [self.aliveStateLock lock];
    _endedRecursively = endedRecursively;
    [self.aliveStateLock unlock];
}

- (BOOL)isRecording {
    BOOL isRecording = NO;
    [self.aliveStateLock lock];
    isRecording = _recording;
    [self.aliveStateLock unlock];
    return isRecording;
}

- (void)setRecording:(BOOL)recording {
    [self.aliveStateLock lock];
    _recording = recording;
    [self.aliveStateLock unlock];
}

@end
