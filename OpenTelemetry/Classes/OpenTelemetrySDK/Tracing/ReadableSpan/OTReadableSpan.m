//
//  OTReadableSpan.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTReadableSpan.h"
#import "OTClock.h"
#import "OTSpanContext.h"
#import "OTSpanId.h"
#import "OTSpanProcessorProtocol.h"
#import "OTLink.h"
#import "OTSpanKind.h"
#import "OTResource.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTSpanDataReportKeys.h"
#import "OTAttribute.h"
#import "OTAttributesWithCapacity.h"
#import "OTArrayWithCapacity.h"
#import "OTEvent.h"
#import "OTReadableSpan+Private.h"
#import "OTSpan+Private.h"

@interface OTReadableSpan ()

@property (nonatomic, assign) NSInteger totalAttributeCount;
@property (nonatomic, assign) NSInteger totalRecordedEvents;

@property (nonatomic, strong) OTAttributesWithCapacity *internalAttributes;
@property (nonatomic, strong) OTArrayWithCapacity<OTEvent *> *internalEvents;
@property (nonatomic, strong) OTArrayWithCapacity<OTLink *> *internalLinks;

@property (nonatomic, assign) NSTimeInterval startEpochNanos;
@property (nonatomic, assign) NSTimeInterval endEpochNanos;

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation OTReadableSpan

- (void)dealloc {
    _lock = nil;
}

- (instancetype)initWithContext:(OTSpanContext *)context name:(NSString *)name {
    if (self = [super init]) {
        self.recording = YES;
        self.context = context;
        self.name = name;
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

#pragma mark - Getter & Setter

- (OTAttributesWithCapacity *)internalAttributes {
    if (!_internalAttributes) {
        _internalAttributes = [[OTAttributesWithCapacity alloc] initWithCapacity:self.maximumAttributes];
    }
    return _internalAttributes;
}

- (OTArrayWithCapacity<OTLink *> *)internalLinks {
    if (!_internalLinks) {
        _internalLinks = [[OTArrayWithCapacity alloc] initWithCapacity:self.maximumLinks];
    }
    return _internalLinks;
}

- (OTArrayWithCapacity<OTEvent *> *)internalEvents {
    if (!_internalEvents) {
        _internalEvents = [[OTArrayWithCapacity alloc] initWithCapacity:self.maximumEvents];
    }
    return _internalEvents;
}

#pragma mark - Public

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    OTSpan *otherSpan = (OTSpan *)object;
    BOOL sameSpan = NO;
    [self.lock lock];
    sameSpan = [self.context.traceParentString isEqualToString:otherSpan.context.traceParentString];
    [self.lock unlock];
    return sameSpan;
}

- (void)startSpan {
    [self startSpanWithTimestamp:self.clock.nanoSecondTime];
}

- (void)startSpanWithTimestamp:(NSTimeInterval)timestamp {
    self.startEpochNanos = timestamp;
    [self.delegate span:self didStartedWithSpanId:self.context.spanIdString];
}

- (void)endRecursively {
    self.endedRecursively = YES;
    [self end];
}

- (void)end {
    [self endWithStatus:OTStatusCanonicalCodeUnset];
}

- (void)endWithStatus:(OTStatusCanonicalCode)status {
    [self endWithStatus:status timestamp:0];
}

- (void)endWithStatus:(OTStatusCanonicalCode)status timestamp:(NSTimeInterval)timestamp {
    self.status = status;
    [self endInternalWithEndTimestamp:timestamp];
}

- (void)endInternalWithEndTimestamp:(NSTimeInterval)timestamp {
    if (!self.isRecording) {
        return;
    }
    // to avoid time paradox, span's end timestamp must be greater than or equal to it's start timestamp
    self.endEpochNanos = timestamp;
    if (self.startEpochNanos > self.endEpochNanos) {
        self.endEpochNanos = self.clock.nanoSecondTime;
    }
    [self.delegate span:self didEndedWithSpanId:self.context.spanIdString];
    self.recording = NO;
}

- (OTSpan *)parentSpanIfNotEnded {
    return [self.delegate parentSpanForSpan:self];
}

- (NSArray<OTAttribute *> *)attributes {
    return self.internalAttributes.attributes;
}

- (NSArray<OTEvent *> *)events {
    return self.internalEvents.array;
}

- (NSArray<OTLink *> *)links {
    return self.internalLinks.array;
}

#pragma mark - OTJsonConvertiable

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    [self.lock lock];
    [jsonObject setValue:self.context.traceIdString forKey:OTSpanDataKeyTraceId];
    [jsonObject setValue:self.context.spanIdString forKey:OTSpanDataKeySpanId];
    [jsonObject setValue:self.parentSpanContext.spanIdString forKey:OTSpanDataKeyParentSpanId];
    [jsonObject setValue:self.name forKey:OTSpanDataKeyName];
    [jsonObject setValue:self.kind forKey:OTSpanDataKeyKind];
    [jsonObject setValue:[NSString stringWithFormat:@"%lld", (uint64_t)_startEpochNanos] forKey:OTSpanDataKeyStartTimeUnixNano];
    [jsonObject setValue:[NSString stringWithFormat:@"%lld", (uint64_t)_endEpochNanos] forKey:OTSpanDataKeyEndTimeUnixNano];

    NSArray *attributeDicts = [self jsonDictArrayFromConvertablObjects:self.attributes];
    [jsonObject setValue:attributeDicts forKey:OTSpanDataKeyAttributes];

    NSArray *events = [self jsonDictArrayFromConvertablObjects:self.events];
    [jsonObject setValue:events forKey:OTSpanDataKeyEvents];

    NSArray *links = [self jsonDictArrayFromConvertablObjects:self.links];
    [jsonObject setValue:links forKey:OTSpanDataKeyLinks];

    NSString *message = self.statusMessage.length > 0 ? self.statusMessage : @"";

    NSDictionary *status = @{
        @"code" : @(self.status),
        @"message" : message,
    };

    [jsonObject setValue:status forKey:OTSpanDataKeyStatus];
    [self.lock unlock];
    return jsonObject;
}

- (NSArray<NSDictionary *> *)jsonDictArrayFromConvertablObjects:(NSArray<id<OTJsonConvertible>> *)convertablObjects {
    NSMutableArray *jsonDictArray = [[NSMutableArray alloc] init];
    [convertablObjects enumerateObjectsUsingBlock:^(id<OTJsonConvertible> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *jsonDict = [obj toJson];
        [jsonDictArray addObject:jsonDict];
    }];
    return jsonDictArray;
}

#pragma mark - Attribute

- (OTAttribute *)attributeForKey:(NSString *)key {
    return [self.internalAttributes attributeForKey:key];
}

- (void)updateAttributeValue:(NSString *)value forKey:(NSString *)key {
    if (!self.isRecording) {
        return;
    }
    OTAttribute *attri = [OTAttribute attributeWithKey:key stringValue:value];
    [self.lock lock];
    [self.internalAttributes updateAttribute:attri];
    [self.lock unlock];
}

- (void)updateAttributeValues:(NSArray<NSString *> *)values forKey:(NSString *)key {
    if (!self.isRecording) {
        return;
    }
    OTAttribute *attri = [OTAttribute attributeWithKey:key values:values];
    [self.lock lock];
    [self.internalAttributes updateAttribute:attri];
    [self.lock unlock];
}

- (void)updateAttribute:(OTAttribute *)attribute {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    [self.internalAttributes updateAttribute:attribute];
    [self.lock unlock];
}

- (void)updateAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (!self.isRecording) {
        return;
    }
    OTAttributesWithCapacity *attriCollection = [OTAttributesWithCapacity attributesCollectionWithDictionary:attributes];
    [self.lock lock];
    [self.internalAttributes updateAttributes:attriCollection.attributes];
    [self.lock unlock];
}

- (void)updateAttributesArray:(NSArray<OTAttribute *> *)attributes {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    [self.internalAttributes updateAttributes:attributes];
    [self.lock unlock];
}

#pragma mark - Event

- (void)addEvent:(OTEvent *)event {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    [self.internalEvents append:event];
    [self.lock unlock];
}

- (void)addEvents:(NSArray<OTEvent *> *)events {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    [self.internalEvents appendWithArray:events];
    [self.lock unlock];
}

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes timeStamp:(int64_t)timeStamp {
    OTAttributesWithCapacity *attriCollection = [OTAttributesWithCapacity attributesCollectionWithDictionary:attributes];
    OTEvent *event = [[OTEvent alloc] initWithNano:timeStamp name:name attributes:attriCollection.attributes capacity:_maximumAttributesPerEvent];
    [self addEvent:event];
}

- (void)addEventWithName:(NSString *)name timeStamp:(int64_t)timeStamp {
    OTEvent *event = [[OTEvent alloc] initWithNano:timeStamp name:name];
    [self addEvent:event];
}

- (void)addEventWithName:(NSString *)name {
    OTEvent *event = [[OTEvent alloc] initWithNano:self.clock.nanoSecondTime name:name];
    [self addEvent:event];
}

- (void)addEventWithName:(NSString *)name attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    [self addEventWithName:name attributes:attributes timeStamp:self.clock.nanoSecondTime];
}

#pragma mark - Link

- (void)addLink:(OTLink *)link {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    [self.internalLinks append:link];
    [self.lock unlock];
}

- (void)addLinks:(NSArray<OTLink *> *)links {
    for (OTLink *link in links) {
        [self addLink:link];
    }
}

- (void)addLinkWithContext:(OTSpanContext *)context {
    [self addLinkWithContext:context attributes:@{}];
}

- (void)addLinkWithContext:(OTSpanContext *)context attributes:(NSDictionary<NSString *, NSString *> *)attributes {
    if (!self.isRecording) {
        return;
    }
    [self.lock lock];
    OTAttributesWithCapacity *attributesCollection = [OTAttributesWithCapacity attributesCollectionWithDictionary:attributes];
    OTLink *newLink = [[OTLink alloc] initWithSpanContext:context attributes:attributesCollection.attributes capacity:_maximumAttributesPerLink];
    [self.internalLinks append:newLink];
    [self.lock unlock];
}

@end
