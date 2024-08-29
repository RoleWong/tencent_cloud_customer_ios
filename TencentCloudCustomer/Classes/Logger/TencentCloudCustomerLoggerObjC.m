//
//  TencentCloudCustomerLoggerObjC.m
//  TencentCloudCustomer
//
//  Created by Role Wong on 8/21/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerLoggerObjC.h"

#import "OTTracing.h"
#import "OTSpan.h"
#import "OTReportEngine.h"


//#import "OpenTelemetry/OTTracing.h"
//#import "OpenTelemetry/OTReportEngine.h"



NSString *const OTDemoTestReportDomainName = @"https://galileotelemetry.tencent.com";

@implementation TencentCloudCustomerLoggerObjC

+ (instancetype)sharedLoggerManager {
    static TencentCloudCustomerLoggerObjC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        OTResource *resource = [OTResource resourceWithTarget:@"iOS.customer.uikit.ios" environment:OTResourceEnvironment_Production];

        OTTracerProvider *provider = [[OTTracerProvider alloc] initWithResource:resource];
        self.tracerProvider = provider;
        
        OTReportEngine *reportEngine = (OTReportEngine *)self.tracerProvider.defaultSpanProcessor.exporter.delegate;
        reportEngine.reportDestinationDomainName = OTDemoTestReportDomainName;
        
        OTSampler *sampler = (OTSampler *)[self.tracerProvider defaultSampler];
        sampler.samplingRate = 1.0;
        
        self.tracer = [self.tracerProvider tracerWithInstrumentationName:@"TencentCloudCustomeriOS" version:@"1.0.0"];
        
        [self startTracing];
        
    }
    return self;
}

- (void)startTracing {
    self.parentSpan = [self.tracer rootSpanWithName:@"TencentCloudCustomeriOS"];
    
    [self.parentSpan addEventWithName:@"TencentCloudCustomeriOS StartEvent" attributes:@{@"key": @"value"}];
    
    [self.parentSpan startSpan];
    [self.parentSpan end];
}

-(OTSpan *)startSpan:(NSString *)eventName attributes:(NSDictionary *)attributes  {
    OTSpan *span = [self.tracer spanWithName:eventName parent:self.parentSpan];
    
    [span addEventWithName:eventName attributes:attributes];
    
    [span startSpan];
    return span;
}

- (void)logEvent:(NSString *)eventName attributes:(NSDictionary *)attributes {
    OTSpan *span = [self.tracer spanWithName:eventName parent:self.parentSpan];
    
    [span addEventWithName:eventName attributes:attributes];
    
    [span startSpan];
    [span end];
}

@end

