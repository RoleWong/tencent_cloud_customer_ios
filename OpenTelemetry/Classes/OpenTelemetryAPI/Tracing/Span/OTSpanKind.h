//
//  SpanKind.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *OTSpanKind NS_STRING_ENUM;

FOUNDATION_EXPORT OTSpanKind const SpanKindInternal;
FOUNDATION_EXPORT OTSpanKind const SpanKindServer;
FOUNDATION_EXPORT OTSpanKind const SpanKindClient;
FOUNDATION_EXPORT OTSpanKind const SpanKindProducer;
FOUNDATION_EXPORT OTSpanKind const SpanKindConsumer;
