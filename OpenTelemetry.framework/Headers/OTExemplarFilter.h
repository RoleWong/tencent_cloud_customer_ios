//
//  OTExemplarFilter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTExemplarFilterProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/// reservoir responsible for getting trace context from tracing module
@interface OTExemplarFilter : NSObject <OTExemplarFilterProtocol>

/// defines how many exemplars each data point can contain, deafault is 1.
@property (nonatomic, assign) NSUInteger maxExemplarsForEachDataPoint;

/// defines what sample mode the filter is taking, see OTExemplarFilterMode
@property (nonatomic, assign) OTExemplarFilterMode mode;

/// user pass an array to tell whether the measurement will converted to exemplar, measurements which has attribute keys that match the keys in this
/// property will be considered as sampled.
@property (nonatomic, strong) NSArray<NSString *> *attrributeKeys;

/// user pass an array to tell whether the measurement will converted to exemplar, measurements which has attribute match the attributes in this
/// property will be considered as sampled.
@property (nonatomic, strong) NSArray<OTAttribute *> *attributes;

/// user pass an callback block to tell whether the measurement will converted to exemplar
@property (nonatomic, copy) OTExemplarFilterResultHandler filterResultCallback;

@end

NS_ASSUME_NONNULL_END
