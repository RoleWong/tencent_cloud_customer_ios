//
//  OTLastValueAggregator.h
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTAggregator.h"

NS_ASSUME_NONNULL_BEGIN

/// this is an aggreegator who will only collect it's latest value as data poiints
@interface OTLastValueAggregator : OTAggregator

@end

NS_ASSUME_NONNULL_END
