//
//  TencentCloudCustomerLoggerObjC.m
//  TencentCloudCustomer
//
//  Created by Role Wong on 8/21/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerLoggerObjC.h"

#import "OTReportEngine.h"


NSString *const TCCCTelemetryDomain = @"https://tpstelemetry.tencent.com";

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
        //        OTResource *resource = [OTResource resourceWithTarget:@"iOS.customer.uikit.ios" environment:OTResourceEnvironment_Production];
        NSArray<OTAttribute *> *attributes = @[
            [OTAttribute attributeWithKey:@"service.name" stringValue:@"ios-customer"],
            [OTAttribute attributeWithKey:@"tps.tenant.id" stringValue:@"tccc"]
        ];
        OTResource *resource = [OTResource resourceWithAttributes:attributes capacity:attributes.count];
        
        // Tracer
        OTTracerProvider *tracerProvider = [[OTTracerProvider alloc] initWithResource:resource];
        self.tracerProvider = tracerProvider;
        
        OTReportEngine *tracerReportEngine = (OTReportEngine *)self.tracerProvider.defaultSpanProcessor.exporter.delegate;
        tracerReportEngine.reportDestinationDomainName = TCCCTelemetryDomain;
        self.tracerProvider.defaultSpanProcessor.exporter.headerForRequest = @{ @"X-Tps-Tenantid" : @"tccc" };
        
        OTSampler *tracerSampler = (OTSampler *)[self.tracerProvider defaultSampler];
        tracerSampler.samplingRate = 1.0;
        
        self.tracer = [self.tracerProvider tracerWithInstrumentationName:@"TencentCloudCustomeriOS" version:@"1.0.0"];
        
        [self startTracing];
        
        // Log
        OTLoggingSinkProvider *logProvider = [[OTLoggingSinkProvider alloc] initWithResource:resource];
        self.logProvider = logProvider;
        
        self.logProvider.defaultLoggingProcessor.onLogReportedCallback
        = ^(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error) {
            NSLog(@"Reported log infos: %@ \n RetCode: %ld \n error: %@ \n", dataString, (long)statusCode, error.localizedDescription);
        };
        
        OTReportEngine *logReportEngine = (OTReportEngine *)self.logProvider.defaultLoggingProcessor.exporter.delegate;
        logReportEngine.reportDestinationDomainName = TCCCTelemetryDomain;
        self.logProvider.defaultLoggingProcessor.exporter.headerForRequest = @{ @"X-Tps-Tenantid" : @"tccc" };
        
        self.logSink = [self.logProvider loggingSinkWithInstrumentationName:@"TencentCloudCustomeriOS" version:@"1.0.0"];
        
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

- (void)logEvent:(NSString *)eventName eventBody:(OTLoggingAnyValue *)eventBody attributes:(NSArray<OTAttribute *> *)attributes {
    OTLoggingRecord *record = [[OTLoggingRecord alloc] init];
    record.severity = OTLoggingRecordSeverityTrace;
    record.name = eventName;
    record.body = eventBody;
    record.attributes = attributes;
    [self.logSink offer:record];
}

- (OTSpan *)reportLogin:(int)sdkAppId userID:(NSString *)userID userSig:(NSString *)userSig {
    NSString *logMessage = [NSString stringWithFormat:@"Tencent Cloud Customer loginWithSdkAppID: %d, userID: %@, and userSig: %@", sdkAppId, userID, userSig];
    
    OTAttribute *environmentAttribute = [OTAttribute
            attributeWithKey:@"client.environment"
                                      stringValue:@"Native"];
    OTAttribute *moduleAttribute = [OTAttribute
            attributeWithKey:@"client.module"
                                      stringValue:@"CustomerClient"];
    OTAttribute *platformAttribute = [OTAttribute
            attributeWithKey:@"client.platform"
                                      stringValue:@"iOS"];
    OTAttribute *sdkAppIdAttribute = [OTAttribute
            attributeWithKey:@"client.sdkAppId"
                                      stringValue:[NSString stringWithFormat:@"%d",sdkAppId]];
    OTAttribute *userIDAttribute = [OTAttribute
            attributeWithKey:@"client.userId"
                                      stringValue:userID];
    OTAttribute *userSigAttribute = [OTAttribute
            attributeWithKey:@"client.userSig"
                                      stringValue:userSig];
    OTAttribute *languageAttribute = [OTAttribute
            attributeWithKey:@"telemetry.sdk.language"
                                      stringValue:@"OC"];
    OTAttribute *versionAttribute = [OTAttribute
            attributeWithKey:@"client.version"
                                      stringValue:@"2.4.0"];
    
    [self logEvent:@"loginWithSdkAppID" eventBody:[[OTLoggingAnyValue alloc] initWithString:logMessage] attributes:@[environmentAttribute, moduleAttribute,platformAttribute, sdkAppIdAttribute, userIDAttribute, userSigAttribute, languageAttribute, versionAttribute]];
    
    NSDictionary *spanAttributes = @{
        @"sdkAppId": @(sdkAppId),
        @"userID": userID,
        @"userSig": userSig
    };
    
    OTSpan *loginSpan = [self startSpan:logMessage attributes:spanAttributes];
    return loginSpan;
}

@end
