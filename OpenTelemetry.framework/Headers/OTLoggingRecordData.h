//
//  OTLoggingRecordData.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTInstrumentationLibraryInfo.h"
#import "OTLoggingRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTLoggingRecordData : OTBaseObject <OTTelemetryDataUnitProtocol>

@property (nonatomic, copy, readonly) OTInstrumentationLibraryInfo *libraryInfo;

@property (nonatomic, strong, readonly) NSDictionary *jsonData;

- (instancetype)initWithLogingRecord:(OTLoggingRecord *)record;

@end

NS_ASSUME_NONNULL_END
