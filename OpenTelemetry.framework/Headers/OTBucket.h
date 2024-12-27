//
//  OTBucket.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTValueTypeDefine.h"
#import "OTSafeArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTBucket : NSObject

/// maximum value of the bucket
@property (nonatomic, strong, readonly) NSNumber *maximumValue;

/// minimum value of the bucket
@property (nonatomic, strong, readonly) NSNumber *minimumValue;

/// refers how much value was captured in this bucket;
@property (nonatomic, assign) NSUInteger countValue;

/// return the bucket should capture the value
/// @param value value
- (BOOL)shouldCaptureValue:(NSNumber *)value;

/// return an array that shows the bucket's boundary
- (NSArray<NSNumber *> *)representBoundsAsNumberArray;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initBucketWithValueType:(OTNumericValueType)valueType
                                minimum:(NSNumber *)minimum
                                maximum:(NSNumber *)maximum NS_DESIGNATED_INITIALIZER;

/// return if the bucket's is qualify for histogram
/// @param bounds bounds description
+ (BOOL)qualifiedForBucketBoundaries:(OTSafeArray<NSNumber *> *)bounds;

/// create a bucket's array
/// @param valueType valueType description
/// @param bounds bounds description
+ (OTSafeArray<OTBucket *> *)bucketsWithValueType:(OTNumericValueType)valueType explictBounds:(OTSafeArray<NSNumber *> *)bounds;

@end

NS_ASSUME_NONNULL_END
