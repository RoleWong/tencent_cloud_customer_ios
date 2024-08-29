//
//  OTLoggingExporter.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoggingExporterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingExporter : NSObject <OTLoggingExporterProtocol>

@end

NS_ASSUME_NONNULL_END
