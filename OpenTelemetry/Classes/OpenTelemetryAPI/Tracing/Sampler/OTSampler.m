//
//  OTSampler.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSampler.h"

#import "OTCallbackHelper.h"
#import "OTDependencyDefine.h"
#import "OTClock.h"

static NSString *const gOpenTelemetrySampleDescisionKey = @"gOpenTelemetrySampleDescisionKey";

@implementation OTSamplerDesicion

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.timeStamp = [coder decodeDoubleForKey:@"timeStamp"];
        self.sampled = [coder decodeBoolForKey:@"sampled"];
    }
    return self;
}

@end

@interface OTSampler ()

@end

@implementation OTSampler

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Getter & Setter

- (id<OTClockProtocol>)clock {
    if (!_clock) {
        _clock = [[OTClock alloc] init];
    }
    return _clock;
}

- (OTSamplerDesicion *)shouldSampleSpanWithName:(NSString *)name
                                           kind:(OTSpanKind)kind
                                         parent:(OTSpanContext *)parent
                                     attributes:(NSArray<OTAttribute *> *)attributes
                                          links:(NSArray<OTLink *> *)links {
    OTSamplerDesicion *desicion = [[OTSamplerDesicion alloc] init];
    desicion.sampled = [self sampleByChance];
    desicion.timeStamp = self.clock.nanoSecondTime;
    return desicion;
}

- (BOOL)sampleByChance {
    double chanceNumber = ((double)arc4random() / UINT32_MAX);
    if (0 < chanceNumber && chanceNumber < (self.samplingRate)) {
        return YES;
    }
    return NO;
}

@end
