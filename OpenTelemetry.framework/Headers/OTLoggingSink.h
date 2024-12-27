//
//  OTLoggingSink.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoggingSinkProtocol.h"

@class OTInstrumentationLibraryInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol OTLoggingSinkDelegate <NSObject>

/**
 *  @brief 记录Log
 *  @param record 需要记录的Log数据
 *  @param info 平台信息
 */
- (void)offerRecord:(OTLoggingRecord *)record instrumentationLibraryInfo:(OTInstrumentationLibraryInfo *)info;

@end

@interface OTLoggingSink : NSObject <OTLoggingSinkProtocol>

/// 平台信息
@property (nonatomic, strong) OTInstrumentationLibraryInfo *instrumentationLibraryInfo;

/// 代理类
@property (nonatomic, weak) id<OTLoggingSinkDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
