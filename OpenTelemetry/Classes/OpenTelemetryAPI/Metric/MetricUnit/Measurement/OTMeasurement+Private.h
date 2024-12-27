//
//  OTMeasurement+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/25.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMeasurement (Private)

/// The name of the Instrument who created this measurement
@property (nonatomic, copy) NSString *name;

/// An optional description of the Instrument who created this measurement
@property (nonatomic, copy) NSString *descriptionInfo;

/// An optional unit of the Instrument who created this measurement
@property (nonatomic, copy) NSString *unit;

@end

NS_ASSUME_NONNULL_END
