//
//  TencentCloudCustomerLoggerObjC.h
//  TencentCloudCustomer
//
//  Created by Role Wong on 8/21/24.
//

#ifndef TencentCloudCustomerLoggerObjC_h
#define TencentCloudCustomerLoggerObjC_h

#import "OTTracing.h"
#import "OTSpan.h"
#import "OTLogging.h"

@interface TencentCloudCustomerLoggerObjC : NSObject

FOUNDATION_EXPORT NSString *const TCCCTelemetryDomain;

@property (nonatomic, strong) OTLoggingSinkProvider *logProvider;

@property (nonatomic, strong) OTTracerProvider *tracerProvider;

@property (nonatomic, strong) id<OTTracerProtocol> tracer;

@property (nonatomic, strong) OTLoggingSink *logSink;

@property (nonatomic, strong) OTSpan *parentSpan;

+ (instancetype) sharedLoggerManager;

- (void)startTracing;

- (void)logEvent:(NSString *)eventName eventBody:(OTLoggingAnyValue *)eventBody attributes:(NSArray<OTAttribute *> *)attributes;

-(OTSpan *)startSpan:(NSString *)eventName attributes:(NSDictionary *)attributes;

- (OTSpan *)reportLogin:(int)sdkAppId userID:(NSString *)userID userSig:(NSString *)userSig;

@end


#endif /* TencentCloudCustomerLoggerObjC_h */
