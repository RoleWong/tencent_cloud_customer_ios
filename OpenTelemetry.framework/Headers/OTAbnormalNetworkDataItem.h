//
//  OTAbnormalNetworkDataItem.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/9.
//  Copyright © 2024 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTAbnormalNetworkDataItem : NSObject

@property (nonatomic, copy) NSString *itemID;

@property (nonatomic, copy) NSString *exportAPI;

@property (nonatomic, copy) NSDictionary *extraParam;
/// to tell whether the carrier carrys a protobuf format data
@property (nonatomic, assign) BOOL protoState;
/// telemetry data that ready to be transfer
@property (nonatomic, strong) NSData *dataInfo;

@property (nonatomic, copy) NSString *dataDescription;

@end

NS_ASSUME_NONNULL_END
