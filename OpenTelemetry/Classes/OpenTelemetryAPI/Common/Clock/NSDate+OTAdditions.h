//
//  NSDate+OTAdditions.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (OTAdditions)

- (NSTimeInterval)ot_nanoSecond;

- (NSTimeInterval)ot_milliSecond;

@end

NS_ASSUME_NONNULL_END
