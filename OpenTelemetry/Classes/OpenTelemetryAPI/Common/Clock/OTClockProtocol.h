//
//  OTClockProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef OTClockProtocol_h
#define OTClockProtocol_h

@protocol OTClockProtocol <NSObject>

/// current time stamp represent as milli second
- (NSTimeInterval)milliSecondTime;

/// current time stamp represent as nano second
- (NSTimeInterval)nanoSecondTime;

@end

#endif /* OTClockProtocol_h */
