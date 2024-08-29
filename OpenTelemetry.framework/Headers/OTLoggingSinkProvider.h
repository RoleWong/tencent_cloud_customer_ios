//
//  OTLoggingSinkProvider.h
//  OpenTelemetry
//
//  Created by jonassun on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoggingProcessorProtocol.h"

@class OTLoggingProcessor, OTLoggingSink, OTResource;
NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingSinkProvider : NSObject

/// associated resources when recording and reporting logs
@property (nonatomic, strong) OTResource *resource;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithResource:(OTResource *)resource;
/**
 * @brief 通过平台信息来获取Log操作类
 * @param name  平台名称
 * @param version  版本号
 */
- (OTLoggingSink *)loggingSinkWithInstrumentationName:(NSString *)name version:(NSString *)version;

/// 注册一个processor用于处理自定义事件
/// @param processor Log导出处理的操作对象
/// @param key 储存用的Key
- (void)registerLogggingProcessor:(id<OTLoggingProcessorProtocol>)processor forKey:(NSString *)key;

/// 移除指定的LoggingProcessor
/// @param key 储存用的Key
- (void)removeLoggingProcessorForKey:(NSString *)key;

/// 获取指定的LoggingProcessor
/// @param key 储存用Key
- (id<OTLoggingProcessorProtocol> _Nullable)loggingProcessorForKey:(NSString *)key;

/// get default logging Processor
- (id<OTLoggingProcessorProtocol> _Nullable)defaultLoggingProcessor;

/// report all log records to back end immediately
- (void)forceFlush;

/// Stop all logging activity at once
- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
