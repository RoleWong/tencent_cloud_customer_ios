//
//  OTSpanContext.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTContextProtocol.h"
#import "OTTraceId.h"
#import "OTSpanId.h"
#import "OTTraceState.h"
#import "OTTraceFlags.h"

NS_ASSUME_NONNULL_BEGIN

/// Span上下文根据文档规范是不可变对象, 因此一旦初始化就不可以修改其属性
@interface OTSpanContext : OTBaseObject <OTContextProtocol>

/// 踪迹的Id
@property (nonatomic, strong, readonly) OTTraceId *traceId;

/// SpanId
@property (nonatomic, strong, readonly) OTSpanId *spanId;

/// 踪迹配置
@property (nonatomic, strong) OTTraceFlags *traceFlags;

/// 踪迹状态
@property (nonatomic, strong, readonly) OTTraceState *traceState;

/// 是否远端Span
@property (nonatomic, assign, getter=isRemote, readonly) BOOL remote;

/// 是否有效
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// 用户传输的字符串格式
@property (nonatomic, copy, readonly) NSString *serializationString;

/// 初始化Span上下文
/// @param traceId 踪迹Id
/// @param spanId SpanId
/// @param traceState 踪迹状态
/// @param isRemote 是否远端Span
- (instancetype)initWithTraceId:(OTTraceId *)traceId
                         spanId:(OTSpanId *)spanId
                     traceState:(OTTraceState *)traceState
                         remote:(BOOL)isRemote;

/// 快速构造Span上下文
/// @param traceId 踪迹Id
/// @param spanId SpanId
/// @param traceState 踪迹状态
/// @param isRemote 是否远端Span
+ (instancetype)spanContextWithTraceId:(OTTraceId *)traceId
                                spanId:(OTSpanId *)spanId
                            traceState:(OTTraceState *)traceState
                                remote:(BOOL)isRemote;

/// 从远端数据获取字符串中解析出Span上下文
/// @param traceParentSerialization 远端序列化的TraceParent
+ (instancetype _Nullable)spanContextWithTraceParent:(NSString *_Nonnull)traceParentSerialization;

/// 从远端数据获取字符串中解析出Span上下文
/// @param traceParentSerialization 远端序列化的TraceParent
/// @param traceStateSerialization 远端序列化的TraceState
+ (instancetype _Nullable)spanContextWithTraceParent:(NSString *_Nonnull)traceParentSerialization
                                          traceState:(NSString *_Nullable)traceStateSerialization;

/// 是否与另一个Span上下文属于一个Trace
/// @param context Span上下文
- (BOOL)inSameTraceWithContext:(OTSpanContext *)context;

@end

NS_ASSUME_NONNULL_END
