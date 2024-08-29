//
//  OTReportEngine.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTReportEngineProtocol.h"
NS_ASSUME_NONNULL_BEGIN

/// 内部使用, 外部调用会有多线程问题
@interface OTReportEngine : NSObject <OTReportEngineProtocol>

/// configure where you want your telemetry data been sent to
@property (nonatomic, copy) NSString *reportDestinationDomainName;

/// maximum retry times for failed requests, 3 by default
@property (nonatomic, assign) NSInteger retryCount;

/// the maximum timeout for a single post request reporesent as second, 30 seconds by default
@property (nonatomic, assign) NSUInteger requestTimeoutInterval;

/// The maximum number of simultaneous connections to make to a given host, 8 by default
@property (nonatomic, assign) NSUInteger maximumConnection;

/// Allow the use of HTTP pipelining,  NO by default
@property (nonatomic, assign) BOOL usePipelining;

@end

NS_ASSUME_NONNULL_END
