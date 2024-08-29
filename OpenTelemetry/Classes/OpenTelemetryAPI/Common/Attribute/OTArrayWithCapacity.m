//
//  ArrayWithCapacity.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTArrayWithCapacity.h"
#import "OTSafeArray.h"

@interface OTArrayWithCapacity <T>()

/// the capacity
@property (nonatomic, assign) NSInteger capacity;

/// used to store objects
@property (nonatomic, strong) OTSafeArray *mutableArray;

/// recorded the drop count of the container
@property (nonatomic, assign) NSInteger droppedCount;

@end

@implementation OTArrayWithCapacity

- (instancetype)initWithCapacity:(NSInteger)capacity {
    if (self = [super init]) {
        _capacity = capacity;
        _mutableArray = [[OTSafeArray alloc] init];
    }
    return self;
}

- (void)append:(id)item {
    [_mutableArray addObject:item];
    if (_mutableArray.count > self.capacity && _mutableArray.count > 0) {
        [_mutableArray removeObjectAtIndex:0];
        _droppedCount += 1;
    }
}

- (void)dropItemAtIndex:(NSInteger)index {
    [_mutableArray removeObjectAtIndex:index];
}

- (void)appendWithArray:(NSArray *)array {
    for (id obj in array) {
        [self append:obj];
    }
}

- (void)appendWithCapacityArray:(OTArrayWithCapacity *)capacityArray {
    [self appendWithArray:capacityArray.array];
}

- (NSArray *)array {
    NSArray *formedArray = [self.mutableArray fetchArray];
    return formedArray;
}

@end
