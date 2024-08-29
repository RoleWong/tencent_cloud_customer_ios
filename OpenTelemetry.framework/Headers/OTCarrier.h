//
//  OTCarrier.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/5/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTCarrier : NSObject

/// telemetry data that ready to be transfer
@property (nonatomic, strong, readonly) NSData *data;

/// description of the data
@property (nonatomic, copy, readonly) NSString *dataDescription;

/// to tell whether the carrier carrys a protobuf format data
@property (nonatomic, assign, getter=isProto, readonly) BOOL proto;

- (instancetype)init NS_UNAVAILABLE;

/// initalize a carrier for data report
/// @param data data
/// @param dataDescription description to helper user debug transfered data
/// @param isProto to tell whether the carrier carrys a proto format data
- (instancetype)initWithData:(NSData *)data description:(NSString *_Nullable)dataDescription isProto:(BOOL)isProto;

/// create a carrier with json object
/// @param jsonObject jsonobject
/// @param error error
+ (OTCarrier *)carrierWithJsonObject:(NSDictionary *)jsonObject error:(NSError **_Nullable)error;

@end

NS_ASSUME_NONNULL_END
