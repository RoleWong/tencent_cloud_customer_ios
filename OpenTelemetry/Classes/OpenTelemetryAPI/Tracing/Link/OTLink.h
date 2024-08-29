//
//  OTLink.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"
#import "OTContextProtocol.h"
#import "OTJsonConvertible.h"

NS_ASSUME_NONNULL_BEGIN

/// Link属于不可变对象, 因此初始化之后就不可以修改其属性
@interface OTLink : OTBaseObject <OTJsonConvertible>

/// 链接所关联到的Span的Span上下文
@property (nonatomic, strong, readonly) id<OTContextProtocol> context;

/// 特征
@property (nonatomic, copy, readonly) NSArray<OTAttribute *> *attributes;

/// 构建一个不可变的链接对象
/// @param context 目标Span的Span上下文
/// @param attributes 特征
- (instancetype)initWithSpanContext:(id<OTContextProtocol>)context
                         attributes:(NSArray<OTAttribute *> *)attributes
                           capacity:(NSInteger)capactiy NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
