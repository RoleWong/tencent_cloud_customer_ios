//
//  OTSpanBizCustomProtocol.h
//  OpenTelemetry
//
//  Created by angelehao on 2023/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OTSpanBizDecoratorProtocol <NSObject>

@optional
/// config the kind of span, if not  implemented, default is SpanKindClient
- (OTSpanKind)spanKind;
/// create span by assign startTime, if not  implemented, default is clock.startEpochNanos
- (NSTimeInterval)startEpochNanos;

@end

NS_ASSUME_NONNULL_END
