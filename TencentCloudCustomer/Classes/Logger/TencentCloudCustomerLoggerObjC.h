//
//  TencentCloudCustomerLoggerObjC.h
//  TencentCloudCustomer
//
//  Created by Role Wong on 8/21/24.
//

#ifndef TencentCloudCustomerLoggerObjC_h
#define TencentCloudCustomerLoggerObjC_h

//#import <OpenTelemetry/OTTracing.h>
//#import <OpenTelemetry/OTSpan.h>

#import "OTTracing.h"
#import "OTSpan.h"

@interface TencentCloudCustomerLoggerObjC : NSObject

FOUNDATION_EXPORT NSString *const OTDemoTestReportDomainName;

@property (nonatomic, strong) OTTracerProvider *tracerProvider;

@property (nonatomic, strong) id<OTTracerProtocol> tracer;

@property (nonatomic, strong) OTSpan *parentSpan;

+ (instancetype) sharedLoggerManager;

- (void)startTracing;

- (void)logEvent:(NSString *)eventName attributes:(NSDictionary *)attributes;

-(OTSpan *)startSpan:(NSString *)eventName attributes:(NSDictionary *)attributes;

@end


#endif /* TencentCloudCustomerLoggerObjC_h */
