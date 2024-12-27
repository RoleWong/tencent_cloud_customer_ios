//
//  OTExemplar.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/21.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTValueTypeDefine.h"
#import "OTContextProtocol.h"
#import "OTJsonConvertible.h"
#import "OTSafeArray.h"

@class OTAttribute;

NS_ASSUME_NONNULL_BEGIN

// (Optional) List of exemplars collected from
// measurements that were used to form the data point
@interface OTExemplar : OTBaseObject <OTJsonConvertible>

/// attribute's recorded by the exemplar
@property (nonatomic, strong) OTSafeArray<OTAttribute *> *filteredAttributes;

/// time when the exemplar was created
@property (nonatomic, assign) NSTimeInterval timeUnixNano;

/// value of the exemplar
@property (nonatomic, strong) NSNumber *value;

/// value type of the exemplar
@property (nonatomic, assign) OTNumericValueType valueType;

/// (Optional) Trace ID of the exemplar trace.
/// trace_id may be missing if the measurement is not recorded inside a trace
/// or if the trace is not sampled.
@property (nonatomic, copy) NSString *traceId;

/// (Optional) Span ID of the exemplar trace.
/// span_id may be missing if the measurement is not recorded inside a trace
/// or if the trace is not sampled.
@property (nonatomic, copy) NSString *spanId;

@end

NS_ASSUME_NONNULL_END
