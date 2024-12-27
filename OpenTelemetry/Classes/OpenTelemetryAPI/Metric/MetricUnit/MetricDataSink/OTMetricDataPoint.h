//
//  OTMetricData.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"
#import "OTValueTypeDefine.h"
#import "OTSafeArray.h"
#import "OTExemplar.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, OTDataPointFlag) {
    OTDataPointFlag_None = 1 << 0,            // default
    OTDataPointFlag_NoRecordedValue = 1 << 1, // this datapoint is invalid
};

/// data point indicate the value of the aggregation in a certain point of time
@interface OTMetricDataPoint : OTBaseObject <OTJsonConvertible>

/// name
@property (nonatomic, copy) NSString *name;

/// Description
@property (nonatomic, copy) NSString *descriptionInfo;

/// unit
@property (nonatomic, copy) NSString *unit;

/// timestamp where the aggregation begin
@property (nonatomic, assign) NSTimeInterval startTimeUnixNano;

/// timestamp when the datapoint is created
@property (nonatomic, assign) NSTimeInterval timeUnixNano;

/// attributes of the datapoints
@property (nonatomic, strong) OTSafeArray<OTAttribute *> *attributes;

/// value type of the data point
@property (nonatomic, assign) OTNumericValueType valueType;

/// see data flag above
@property (nonatomic, assign, readonly) OTDataPointFlag flag;

/// exemplars which help forming the data point
@property (nonatomic, strong) OTSafeArray<OTExemplar *> *exemplars;

/// to tell wether this datapoint is valid
- (BOOL)isValidDataPoint;

@end

NS_ASSUME_NONNULL_END
