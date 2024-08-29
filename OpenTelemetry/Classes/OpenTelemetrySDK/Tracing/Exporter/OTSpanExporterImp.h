//
//  OTSpanExporterImp.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/8/24.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTSpanExporterProtocol.h"
#import "OTReportEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSpanExporterImp : NSObject <OTSpanExporterProtocol>

/// instance that responsible for reporting span data
@property (nonatomic, strong) id<OTReportEngineProtocol> delegate;

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headerForRequest;

@end

NS_ASSUME_NONNULL_END
