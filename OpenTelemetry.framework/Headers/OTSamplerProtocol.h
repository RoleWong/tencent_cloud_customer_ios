//
//  OTSamplerProtocol.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAttribute.h"
#import "OTSpanKind.h"
#import "OTSpan.h"

@class OTSpanContext, OTTraceId, OTLink, OTSamplerDesicion;

NS_ASSUME_NONNULL_BEGIN

@protocol OTSamplerProtocol <NSObject>

/// this method was called to decide wether the span will be upload or not when creating span;
/// @param name name of the span
/// @param parent the source of the span
/// @param attributes attributes that help user to regulate the decistion
/// @param links the span maybe links to other span
- (OTSamplerDesicion *)shouldSampleSpanWithName:(NSString *)name
                                           kind:(OTSpanKind)kind
                                         parent:(OTSpanContext *)parent
                                     attributes:(NSArray<OTAttribute *> *)attributes
                                          links:(NSArray<OTLink *> *)links;

/// the rate of sampling when a single span is ready to export
@property (nonatomic, assign) double samplingRate;

@end

NS_ASSUME_NONNULL_END
