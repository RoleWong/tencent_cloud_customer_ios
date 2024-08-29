//
//  OTLastValueAggregation.m
//  CocoaAsyncSocket
//
//  Created by ravendeng on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLastValueAggregation.h"
#import "OTAggregatorProtocol.h"

@implementation OTLastValueAggregation

- (instancetype)init {
    if (self = [super init]) {
        self.type = OTAggregatorTypeLastValue;
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:[super toJson]];
    return result;
}

@end
