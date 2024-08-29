//
//  OTClock.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTClock.h"
#import "NSDate+OTAdditions.h"
#import "OTDependencyDefine.h"
#ifdef OT_NTPCLOCK_SDK_CLOCK
#import "OTNTPClock.h"
#endif

@interface OTClock ()

#ifdef OT_NTPCLOCK_SDK_CLOCK
@property (nonatomic, strong) OTNTPClock *ntpClock;
#endif

@end

@implementation OTClock

- (instancetype)init {
    if (self = [super init]) {
#ifdef OT_NTPCLOCK_SDK_CLOCK
        _ntpClock = [OTNTPClock sharedNTPClock];
#endif
    }
    return self;
}

- (NSTimeInterval)milliSecondTime {
    NSTimeInterval result = [[NSDate date] ot_milliSecond];
#ifdef OT_NTPCLOCK_SDK_CLOCK
    result = [self.ntpClock milliSecondTime];
#endif
    return result;
}

- (NSTimeInterval)nanoSecondTime {
    NSTimeInterval result = [[NSDate date] ot_nanoSecond];
#ifdef OT_NTPCLOCK_SDK_CLOCK
    result = [self.ntpClock nanoSecondTime];
#endif
    return result;
}

@end
