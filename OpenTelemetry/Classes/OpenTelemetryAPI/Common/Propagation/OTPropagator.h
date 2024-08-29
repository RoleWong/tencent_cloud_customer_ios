//
//  OTPropagator.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTSpanContext;

@protocol OTPropagateSetter <NSObject>

/// 设置值到指定的Field
/// @param value 值
/// @param key 键
/// @param carrier 容器
- (void)updateValue:(id)value key:(NSString *)key carrier:(id)carrier;

@end

@protocol OTPropagateGetter <NSObject>

/// 从指定的Field提取值
/// @param key 键
/// @param carrier 容器
- (id)getValueForKey:(NSString *)key carrier:(id)carrier;

@end

@protocol OTHTTPTextFormattable <NSObject>

/// 根据指定的上下文注入字段
/// @param context 上下文
/// @param carrier 携带传值字段的对象,例如HTTP请求
/// @param setter 添加或移除每个传值键的Setter
- (void)injectWithContext:(OTSpanContext *)context carrier:(id)carrier setter:(id<OTPropagateSetter>)setter;

/// 根据当前的上下文注入字段
/// @param carrier 携带传值字段的对象,例如HTTP请求
/// @param setter 添加或移除每个传值键的Setter
- (void)injectWithCarrier:(id)carrier setter:(id<OTPropagateSetter>)setter;

/// 根据指定的上下文提取字段中的值
/// @param context 上下文
/// @param carrier 携带传值字段的对象,例如HTTP请求
/// @param getter 用于获取每个传值键的Getter
- (OTSpanContext *)extractWithContext:(OTSpanContext *)context carrier:(id)carrier getter:(id<OTPropagateGetter>)getter;

/// 根据当前上下文提取字段中的值
/// @param carrier 携带传值字段的对象,例如HTTP请求
/// @param getter 用于获取每个传值键的Getter
- (OTSpanContext *)extractWithCarrier:(id)carrier getter:(id<OTPropagateGetter>)getter;

@end

@protocol OTPropagator <NSObject>

@property (nonatomic, strong, readonly) id<OTHTTPTextFormattable> httpTextFormat;

@end
