//
//  OTMeterProvider.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/7/20.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMeterProviderProtocol.h"

@class OTResource;

NS_ASSUME_NONNULL_BEGIN

@interface OTMeterProvider : NSObject <OTMeterProviderProtocol>

/// global informations that will attached to all metric data generated from this provider
@property (nonatomic, strong, nullable) OTResource *resource;

- (instancetype)initWithResource:(OTResource *_Nullable)resource;

@end

NS_ASSUME_NONNULL_END
