//
//  ArrayWithCapacity.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTAttribute.h"

NS_ASSUME_NONNULL_BEGIN

/// The collection of objects
@interface OTArrayWithCapacity<T> : OTBaseObject

/// return the attributes collection represent as array
@property (nonatomic, copy, readonly) NSArray *array;

/// dropped attributes due to overwhelming objects
@property (nonatomic, assign, readonly) NSInteger droppedCount;

/// get an instance of objects collection
/// @param capacity the capacity
- (instancetype)initWithCapacity:(NSInteger)capacity;

/// append an attribute
/// @param item item description
- (void)append:(T)item;

/// remove the object at index
/// @param index index
- (void)dropItemAtIndex:(NSInteger)index;

/// append objects to collection
/// @param array the array of objects
- (void)appendWithArray:(NSArray *)array;

/// appent object from another capacity array
/// @param capacityArray capacityArray
- (void)appendWithCapacityArray:(OTArrayWithCapacity *)capacityArray;

@end

NS_ASSUME_NONNULL_END
