//
//  OTMetricExporter.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMetricExporterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTMetricExporter : NSObject <OTMetricExporterProtocol>

@end

NS_ASSUME_NONNULL_END
