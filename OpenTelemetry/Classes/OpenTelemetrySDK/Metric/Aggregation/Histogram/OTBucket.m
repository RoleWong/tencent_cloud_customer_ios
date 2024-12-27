//
//  OTBucket.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBucket.h"

@interface OTBucket ()

@property (nonatomic, strong) NSNumber *maximumValue;

@property (nonatomic, strong) NSNumber *minimumValue;

@property (nonatomic, assign) OTNumericValueType valueType;

@end

@implementation OTBucket

- (instancetype)initBucketWithValueType:(OTNumericValueType)valueType minimum:(NSNumber *)minimum maximum:(NSNumber *)maximum {
    if (self = [super init]) {
        _valueType = valueType;
        _minimumValue = minimum;
        _maximumValue = maximum;
    }
    return self;
}

- (BOOL)shouldCaptureValue:(NSNumber *)value {
    BOOL withIn = NO;
    if (self.valueType == OTNumericValueTypeLong) {
        NSInteger longValue = value.integerValue;
        NSInteger max = self.maximumValue.integerValue;
        NSInteger min = self.minimumValue.integerValue;

        withIn = longValue >= min && longValue < max;
    } else if (self.valueType == OTNumericValueTypeDouble) {
        NSTimeInterval doubleValue = value.doubleValue;
        NSTimeInterval max = self.maximumValue.doubleValue;
        NSTimeInterval min = self.minimumValue.doubleValue;

        withIn = doubleValue >= min && doubleValue < max;
    }
    if (withIn) {
        self.countValue += 1;
    }
    return withIn;
}

- (NSArray<NSNumber *> *)representBoundsAsNumberArray {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:self.minimumValue];
    [result addObject:self.maximumValue];
    return result;
}

+ (OTSafeArray<OTBucket *> *)bucketsWithValueType:(OTNumericValueType)valueType explictBounds:(OTSafeArray<NSNumber *> *)bounds {
    OTSafeArray *result = [[OTSafeArray alloc] init];
    NSArray *boundsTemp = [bounds fetchArray];
    [boundsTemp enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == bounds.count - 1) {
            return;
        }
        NSUInteger maxValueIndex = idx + 1;
        NSNumber *maxValue = [boundsTemp objectAtIndex:maxValueIndex];
        OTBucket *bucket = [[OTBucket alloc] initBucketWithValueType:valueType minimum:obj maximum:maxValue];
        [result addObject:bucket];
    }];
    // Add first and last bucket
    NSNumber *minBounds = bounds.firstObject;
    NSNumber *maxBounds = bounds.lastObject;
    OTBucket *firstBucket = [[OTBucket alloc] initBucketWithValueType:valueType minimum:@(NSIntegerMin) maximum:minBounds];
    OTBucket *lastBucket = [[OTBucket alloc] initBucketWithValueType:valueType minimum:maxBounds maximum:@(NSIntegerMax)];
    [result insertObject:firstBucket atIndex:0];
    [result addObject:lastBucket];
    return result;
}

+ (BOOL)qualifiedForBucketBoundaries:(OTSafeArray<NSNumber *> *)bounds {
    // at least 2 number is required to form boundaries
    return bounds.count >= 2;
}

@end
