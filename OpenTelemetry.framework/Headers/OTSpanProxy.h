//
//  OTSpanProxy.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/2.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpan.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSpanProxy : NSObject <OTSpanDelegate>

- (instancetype)initWithTarget:(id<OTSpanDelegate>)target;

@end

NS_ASSUME_NONNULL_END
