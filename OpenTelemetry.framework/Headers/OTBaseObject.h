//
//  OTBaseObject.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// this class will provider auto implentmentation of archiving and unarchiving support
@interface OTBaseObject : NSObject <NSCoding, NSCopying, NSSecureCoding>

@end

NS_ASSUME_NONNULL_END
