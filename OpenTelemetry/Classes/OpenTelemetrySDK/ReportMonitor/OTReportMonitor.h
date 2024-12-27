//
//  OTReportMonitor.h
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTResource;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const OpenTelemetryMetricHookNotification;
FOUNDATION_EXPORT NSNotificationName const OpenTelemetryLoggingHookNotification;
FOUNDATION_EXPORT NSNotificationName const OpenTelemetrySpanHookNotification;

FOUNDATION_EXPORT NSString *const OpenTelemetryReportDataKeyResource;
FOUNDATION_EXPORT NSString *const OpenTelemetryReportDataKeyResult;

@interface OTReportMonitor : NSObject

/// get singleton instance
+ (instancetype)defaultMonitor;

/// start hook export method to report export results
/// @param domainName domainName
- (void)hookExportResultsToDomainName:(NSString *)domainName;

/// when this method is called, shutdown all monitor report
- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
