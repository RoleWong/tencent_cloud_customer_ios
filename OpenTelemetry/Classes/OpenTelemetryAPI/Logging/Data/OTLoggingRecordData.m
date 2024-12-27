//
//  OTLoggingRecordData.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTLoggingRecordData.h"

@interface OTLoggingRecordData ()

@property (nonatomic, copy) OTInstrumentationLibraryInfo *libraryInfo;

@property (nonatomic, strong) NSDictionary *jsonData;

@end

@implementation OTLoggingRecordData

- (instancetype)initWithLogingRecord:(OTLoggingRecord *)record {
    if (self = [super init]) {
        self.libraryInfo = record.instrumentationLibraryInfo;
        self.jsonData = [record toJson];
    }
    return self;
}

- (NSDictionary *)toJson {
    return self.jsonData;
}

@end
