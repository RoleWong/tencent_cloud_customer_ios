//
//  OTLoggingSinkProtocol.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/4.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OTLoggingRecord;

@protocol OTLoggingSinkProtocol <NSObject>

- (void)offer:(OTLoggingRecord *)record;

@end

NS_ASSUME_NONNULL_END
