//
//  OTCarrier.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTCarrier.h"
#import "NSObject+OTJsonTools.h"

@interface OTCarrier ()

/// telemetry data that ready to be transfer
@property (nonatomic, strong) NSData *data;

/// description of the data
@property (nonatomic, copy) NSString *dataDescription;

/// to tell whether the carrier carrys a protobuf format data
@property (nonatomic, assign, getter=isProto) BOOL proto;

@end

@implementation OTCarrier

- (instancetype)initWithData:(NSData *)data description:(NSString *_Nullable)dataDescription isProto:(BOOL)isProto {
    if (self = [super init]) {
        _data = data;
        _dataDescription = dataDescription;
        _proto = isProto;
    }
    return self;
}

+ (OTCarrier *)carrierWithJsonObject:(NSDictionary *)jsonObject error:(NSError **_Nullable)error {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:error];
    NSString *jsonDescription = [jsonObject ot_jsonStringWithError:error];
    OTCarrier *jsonCarrier = [[OTCarrier alloc] initWithData:jsonData description:jsonDescription isProto:NO];
    return jsonCarrier;
}

@end
