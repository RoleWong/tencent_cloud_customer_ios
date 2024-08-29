//
//  OTAbnormalNetworkDBManager.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/9.
//  Copyright © 2024 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAbnormalNetworkDBProtocol.h"
#import "OTAbnormalNetworkDataItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 离线OpenTelemetry上报数据缓存信息，在数据库中的表字段名字
 */
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBFileName;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBTableName;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBColumnItemId;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBColumnExportAPI;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBColumnExtraParam;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBColumnProtoState;
FOUNDATION_EXPORT NSString *const gOTAbNetInfoDBColumnDataInfo;

@interface OTAbnormalNetworkDBManager : NSObject

/**
 * 注册db service； 是否启用延时上报enableDelayExport
 */
+ (void)registerOTDBService:(id<OTAbnormalNetworkDBProtocol>)dbService;

+ (instancetype)shareInstance;

- (void)setupEnableDelayExport:(BOOL)enableDelayExport withRecordMaxCount:(NSInteger)tableMaxRecordCount;

/**
 * 获取是否启动延时上报
 */
- (BOOL)enableDelayExport;

/**
 * 当前是否有网络
 */
- (BOOL)isNetworkAvailable;

/**
 * 插入单条数据model 信息到数据库
 */
- (BOOL)insertItemInfo:(OTAbnormalNetworkDataItem *)itemInfo;

/**
 * 批量插入异常网络数据model 信息到数据库
 */
- (BOOL)insertItemInfoList:(NSArray<OTAbnormalNetworkDataItem *> *)itemInfoList;

/**
 * 获取所有数据库model
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchAllItemInfoList;

/**
 * 根据itemId查询item信息
 */
- (OTAbnormalNetworkDataItem *)fetchItemInfoDataWithItemID:(NSString *)itemId;

/**
 * 根据itemIDList删除数据
 */
- (BOOL)deleteDataWithItemList:(NSArray<OTAbnormalNetworkDataItem *> *)itemList;

/**
 * 根据单个item数据
 */
- (BOOL)deleteDataWithItem:(OTAbnormalNetworkDataItem *)item;

/**
 * 删除数据库表
 */
- (BOOL)deleteTableWithSQL:(NSString *)tableSQL;

/**
 * 获取Limit条记录
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchItemInfoWithLimitCount:(NSUInteger)limitCount;

@end

NS_ASSUME_NONNULL_END
