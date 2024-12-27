//
//  IdsGenerator.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTTraceId.h"
#import "OTSpanId.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTIdsGenerator

- (OTSpanId *)generateSpanId;
- (OTTraceId *)generateTraceId;

@end

NS_ASSUME_NONNULL_END
