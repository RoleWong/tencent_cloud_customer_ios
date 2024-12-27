//
//  OTSpanData.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpan.h"
#import "OTInstrumentationLibraryInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSpanData : OTBaseObject <OTTelemetryDataUnitProtocol>

@property (nonatomic, copy, readonly) OTInstrumentationLibraryInfo *libraryInfo;

@property (nonatomic, copy, readonly) NSDictionary *jsonData;

- (instancetype)initWithSpan:(OTSpan *)span;

@end

NS_ASSUME_NONNULL_END
