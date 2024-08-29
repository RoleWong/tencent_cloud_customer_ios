//
//  OTLoggingExporterImp.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoggingExporterProtocol.h"
#import "OTReportEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingExporterImp : NSObject <OTLoggingExporterProtocol>

/// instance that responsible for reporting span data
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

/// config the header of the teelemetry data report request
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

@end

NS_ASSUME_NONNULL_END
