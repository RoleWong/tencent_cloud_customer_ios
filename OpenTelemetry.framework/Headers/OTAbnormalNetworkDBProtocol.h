//
//  OTAbnormalNetworkDBProtocol.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/18.
//

#import <Foundation/Foundation.h>
#import "OTAbnormalNetworkDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTAbnormalNetworkDBProtocol <NSObject>

/**
 * 创建异常网络数据库表
 */
- (BOOL)createDatabaseQueueWithPath:(NSString *)path dBTableSQL:(NSString *)tableSQL triggerSQL:(NSString *)triggerSQL;

/**
 * 删除数据库表
 */
- (BOOL)deleteTableWithSQL:(NSString *)tableSQL;

/**
 * 插入单条数据model 信息到数据库
 */
- (BOOL)insertItemInfo:(OTAbnormalNetworkDataItem *)itemInfo withSQL:(NSString *)insertSQL;

/**
 * 批量插入异常网络数据model 信息到数据库，线程安全
 */
- (BOOL)insertItemInfoList:(NSArray<OTAbnormalNetworkDataItem *> *)itemInfoList withSQL:(NSString *)insertSQL;

/**
 * 获取Limit条记录
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchLimitCountItemInfoListWithSQL:(NSString *)fetchLimitCountSQL;

/**
 * 获取所有数据库model
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchAllItemInfoListWithSQL:(NSString *)fetchAllSQL;

/**
 * 根据itemId查询item信息
 */
- (OTAbnormalNetworkDataItem *)fetchItemInfoDataWithItemID:(NSString *)itemId withSQL:(NSString *)fetchSQL;

/**
 * 根据itemList删除数据
 */
- (BOOL)deleteDataWithItemList:(NSArray<OTAbnormalNetworkDataItem *> *)itemList withSQL:(NSString *)deleteSQL;

/**
 * 根据单个item数据
 */
- (BOOL)deleteDataWithItem:(OTAbnormalNetworkDataItem *)item withSQL:(NSString *)deleteSQL;

/**
 * 查询表内记录个数
 */
- (NSUInteger)numberOfCurrentItemsInDBWithSQL:(NSString *)queryAllCountSQL;

/**
 * 当前是否有网络
 */
- (BOOL)isNetworkAvailable;

@end

NS_ASSUME_NONNULL_END
