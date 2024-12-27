//
//  OTMetricDataSink.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/19.
//  Copyright (c) 2021 ravendeng. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTResource.h"
#import "OTMetricData.h"

NS_ASSUME_NONNULL_BEGIN

/// data sink is a data container for metric data report
@interface OTMetricDataSink : OTBaseObject <OTJsonConvertible>

/// instrumentation libaray info of the meter
@property (nonatomic, strong) OTInstrumentationLibraryInfo *libraryInfo;

/// collected metric data
@property (nonatomic, strong) OTSafeArray<OTMetricData *> *metricDatas;

@end

NS_ASSUME_NONNULL_END
