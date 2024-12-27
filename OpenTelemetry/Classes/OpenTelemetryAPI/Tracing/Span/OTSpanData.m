//
//  OTSpanData.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/3/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTSpanData.h"

@interface OTSpanData ()

@property (nonatomic, copy) OTInstrumentationLibraryInfo *libraryInfo;

@property (nonatomic, copy) NSDictionary *jsonData;

@end

@implementation OTSpanData

- (instancetype)initWithSpan:(OTSpan *)span {
    if (self = [super init]) {
        self.libraryInfo = span.libraryInfo;
        self.jsonData = [span toJson];
    }
    return self;
}

- (NSDictionary *)toJson {
    return self.jsonData;
}

@end
