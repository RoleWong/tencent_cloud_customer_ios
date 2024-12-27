//
//  OTCounter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTUpDownCounter.h"

NS_ASSUME_NONNULL_BEGIN

/// Counter is an instrument creating increment value called by user. Its value must be non-negateive
@interface OTCounter : OTUpDownCounter

@end

NS_ASSUME_NONNULL_END
