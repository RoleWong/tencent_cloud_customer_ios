//
//  OTMetricReaderImp.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTMetricReaderProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/// Metric reader responsible for creating meteric data points in a certain period, and collect metic data to exporter when  exporter is ready to
/// export
@interface OTMetricReaderImp : NSObject <OTMetricReaderProtocol>

@end

NS_ASSUME_NONNULL_END
