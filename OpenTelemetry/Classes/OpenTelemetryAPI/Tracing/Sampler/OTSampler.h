//
//  OTSampler.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/23.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTSamplerProtocol.h"
#import "OTClockProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OTSamplerImpResultBlock) (NSError  * _Nullable  error, OTSamplerDesicion * _Nonnull desicion);

@interface OTSamplerDesicion : NSObject

@property (nonatomic, assign, getter = isSampled) BOOL sampled;
@property (nonatomic, assign) NSTimeInterval timeStamp;

@end

@interface OTSampler : NSObject <OTSamplerProtocol>

@property (nonatomic, strong) id<OTClockProtocol> clock;

/// the rate of sampling when a single span is ready to export
@property (nonatomic, assign) double samplingRate;

@end

NS_ASSUME_NONNULL_END
