//
//  OTLoggingSinkProvider.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingSinkProvider.h"
#import "OTSafeDictionary.h"
#import "OTLoggingSink.h"
#import "OTLoggingProcessor.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTLoggingRecord.h"

@interface OTLoggingSinkProvider () <OTLoggingSinkDelegate>
@property (nonatomic, strong) OTSafeDictionary *loggingSinks;
@property (nonatomic, strong) OTSafeDictionary<NSString *, id<OTLoggingProcessorProtocol>> *processors;
@end

@implementation OTLoggingSinkProvider

- (instancetype)initWithResource:(OTResource *)resource {
    if (self = [super init]) {
        _loggingSinks = [[OTSafeDictionary alloc] init];
        _processors = [[OTSafeDictionary alloc] init];
        _resource = resource;
        [self addDefaltProcessorWithResource];
    }
    return self;
}

- (OTLoggingSink *)loggingSinkWithInstrumentationName:(NSString *)name version:(NSString *)version {
    OTInstrumentationLibraryInfo *info = [[OTInstrumentationLibraryInfo alloc] initWithName:name version:version];
    NSString *infoKey = info.key;
    OTLoggingSink *sink = [self.loggingSinks objectForKey:infoKey];
    if (!sink) {
        sink = OTLoggingSink.new;
        sink.delegate = self;
        sink.instrumentationLibraryInfo = info;
        [self.loggingSinks setValue:sink forKey:infoKey];
    }
    return sink;
}

- (void)addDefaltProcessorWithResource {
    OTLoggingProcessor *processor = [[OTLoggingProcessor alloc] init];
    [self registerLogggingProcessor:processor forKey:@"defaultLoggingProcessor"];
}

- (void)registerLogggingProcessor:(id<OTLoggingProcessorProtocol>)processor forKey:(NSString *)key {
    processor.resource = self.resource;
    [self.processors setValue:processor forKey:key];
}

- (void)removeLoggingProcessorForKey:(NSString *)key {
    [self.processors removeObjectForKey:key];
}

- (id<OTLoggingProcessorProtocol>)loggingProcessorForKey:(NSString *)key {
    return [self.processors objectForKey:key];
}

- (id<OTLoggingProcessorProtocol>)defaultLoggingProcessor {
    return [self loggingProcessorForKey:@"defaultLoggingProcessor"];
}

- (void)forceFlush {
    [self.processors enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTLoggingProcessorProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        [obj forceFlush];
    }];
}

- (void)shutdown {
    [self.processors enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTLoggingProcessorProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        [obj shutdown];
    }];
}

#pragma mark - OTLoggingSinkDelegate

- (void)offerRecord:(OTLoggingRecord *)record instrumentationLibraryInfo:(nonnull OTInstrumentationLibraryInfo *)info {
    record.instrumentationLibraryInfo = info;
    [self.processors enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<OTLoggingProcessorProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        [obj addLogRecord:record];
    }];
}

@end
