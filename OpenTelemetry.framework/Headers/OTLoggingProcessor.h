//
//  OTLoggingProcessor.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoggingProcessorProtocol.h"

@class OTResource, OTInstrumentationLibraryInfo;
NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingProcessor : NSObject <OTLoggingProcessorProtocol>

@end

NS_ASSUME_NONNULL_END
