//
//  OTReadableSpan+Private.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/2.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTReadableSpan.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTReadableSpan (Private)

@property (nonatomic, strong) id<OTClockProtocol> clock;

@end

NS_ASSUME_NONNULL_END
