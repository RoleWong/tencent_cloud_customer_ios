//
//  OTAbnormalNetworkDBManager.m
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/9.
//  Copyright © 2024 Tencent Inc. All rights reserved.
//

#import "OTAbnormalNetworkDBManager.h"
#import "OTAbnormalNetworkDBProtocol.h"

/**
 * 离线OpenTelemetry上报数据缓存信息，在数据库中的表字段名字
 */
NSString *const gOTAbNetInfoDBFileName = @"cache_ot_abnormal_network_info.sqlite";
NSString *const gOTAbNetInfoDBTableName = @"cache_ot_abnormal_network_info";
NSString *const gOTAbNetInfoDBColumnItemId = @"item_id";
NSString *const gOTAbNetInfoDBColumnExportAPI = @"export_api";
NSString *const gOTAbNetInfoDBColumnExtraParam = @"extra_param";
NSString *const gOTAbNetInfoDBColumnProtoState = @"proto_state";
NSString *const gOTAbNetInfoDBColumnDataInfo = @"data_info";

/**
 * 创建table操作DB的SQL语句
 */
static NSString *const gSQLCreateTable = @"CREATE TABLE IF NOT EXISTS %@ ("
                                          "id integer primary key autoincrement,"
                                          "%@ text,"
                                          "%@ text,"
                                          "%@ BLOB,"
                                          "%@ boolean,"
                                          "%@ BLOB)";

/**
 * 设置表中记录最高条数
 */
static NSString *gSQLTriggerSQL = @"CREATE TRIGGER IF NOT EXISTS check_data_count "
                                   "BEFORE INSERT "
                                   "ON %@ FOR EACH ROW "
                                   "BEGIN "
                                   "SELECT CASE "
                                   "WHEN (SELECT COUNT(*) FROM %@) >= %@ THEN "
                                   "RAISE (ABORT, '数据总数已达到限制（%@）') "
                                   "END; "
                                   "END;";

/**
 * 插入表字段值，进行DB更新操作
 */
static NSString *const gSQLReplaceInfo = @"REPLACE INTO %@ (%@, %@, %@, %@, %@) values(?, ?, ?, ?, ?)";
/**
 * 删除记录
 */
static NSString *const gSQLDeleteInfo = @"DELETE FROM %@ WHERE %@ = ?";
/**
 * 获取某条记录
 */
static NSString *const gSQLQueryInfo = @"SELECT * FROM %@ WHERE %@ = ?";
/**
 * 获取某张表所有记录
 */
static NSString *const gSQLQueryAllInfo = @"SELECT * FROM %@";

static NSString *const gSQLQueryCounts = @"SELECT COUNT(*) FROM %@";
/**
 * 获取某张表中Limit Count数
 */
static NSString *const gSQLQueryLimitCountsInfo = @"SELECT * FROM %@ LIMIT %@";
/**
 * 数据库最大行数增加到1000条, 每条占用空间约为log为20kb，trace极端600kb , 总占用空间不超过600MB
 */
static NSUInteger const gDefaultTelemtryDBMaxSize = 1000;

@interface OTAbnormalNetworkDBManager ()

@property (nonatomic, strong) id<OTAbnormalNetworkDBProtocol> serviceImp;

@property (nonatomic, assign) BOOL needEnableDelayExport;

@end

@implementation OTAbnormalNetworkDBManager

+ (void)registerOTDBService:(id<OTAbnormalNetworkDBProtocol>)dbService {
    [OTAbnormalNetworkDBManager shareInstance].serviceImp = dbService;
}

+ (instancetype)shareInstance {
    static OTAbnormalNetworkDBManager *dbMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbMgr = [[OTAbnormalNetworkDBManager alloc] init];
        
    });
    return dbMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setupEnableDelayExport:(BOOL)enableDelayExport withRecordMaxCount:(NSInteger)tableMaxRecordCount {
    _needEnableDelayExport = enableDelayExport;
    // 先查询表中行数的总个数
    [self createOTAbNetInfoTableWithRecordMaxCount:tableMaxRecordCount];
}

- (BOOL)enableDelayExport {
    return self.needEnableDelayExport;
}

- (NSUInteger)numberOfCurrentItemsInDB {
    // 先查询表中行数的总个数
    NSString *queryAllCountSQL = [NSString stringWithFormat:gSQLQueryCounts, gOTAbNetInfoDBTableName];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(numberOfCurrentItemsInDBWithSQL:)]) {
        return [self.serviceImp numberOfCurrentItemsInDBWithSQL:queryAllCountSQL];
    }
    return 0;
}

#pragma mark - Public Interface

/**
 * 创建数据库表
 */
- (void)createOTAbNetInfoTableWithRecordMaxCount:(NSInteger)tableMaxRecordCount {
    NSString *dbQueuePath = [NSString stringWithFormat:@"%@/%@", [OTAbnormalNetworkDBManager getDocumentsPath], gOTAbNetInfoDBFileName];
    NSString *createTableSQL =
        [NSString stringWithFormat:gSQLCreateTable, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId, gOTAbNetInfoDBColumnExportAPI,
                                   gOTAbNetInfoDBColumnExtraParam, gOTAbNetInfoDBColumnProtoState, gOTAbNetInfoDBColumnDataInfo];

    if (tableMaxRecordCount <= 0) {
        tableMaxRecordCount = gDefaultTelemtryDBMaxSize;
    }
    // 创建触发器
    NSString *maxCountStr = [NSString stringWithFormat:@"%ld", (long)tableMaxRecordCount];
    NSString *triggerSQL = [NSString stringWithFormat:gSQLTriggerSQL, gOTAbNetInfoDBTableName, gOTAbNetInfoDBTableName, maxCountStr, maxCountStr];

    [self createDatabaseQueueWithPath:dbQueuePath dBTableSQL:createTableSQL triggerSQL:triggerSQL];
}

/**
 * 删除数据库表
 */
- (BOOL)deleteTableWithSQL:(NSString *)tableSQL {
    NSString *deleteTableSQL = [[self class] deleteTableSQL];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(deleteTableWithSQL:)]) {
        return [self.serviceImp deleteTableWithSQL:deleteTableSQL];
    }
    return NO;
}

- (BOOL)createDatabaseQueueWithPath:(NSString *)databasePath dBTableSQL:(NSString *)tableSQL triggerSQL:(nonnull NSString *)triggerSQL {
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(createDatabaseQueueWithPath:dBTableSQL:triggerSQL:)]) {
        return [self.serviceImp createDatabaseQueueWithPath:databasePath dBTableSQL:tableSQL triggerSQL:triggerSQL];
    }
    return NO;
}

/**
 * 当前是否有网络
 */
- (BOOL)isNetworkAvailable {
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(isNetworkAvailable)]) {
        return [self.serviceImp isNetworkAvailable];
    }
    return YES;
}

/**
 * 批量插入异常网络数据model 信息到数据库，线程安全
 */
- (BOOL)insertItemInfoList:(NSArray<OTAbnormalNetworkDataItem *> *)itemInfoList {
    if (!itemInfoList && !itemInfoList.count) {
        return NO;
    }
    NSString *insertDataSQL = [OTAbnormalNetworkDBManager insertDataSQL];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(insertItemInfoList:withSQL:)]) {
        return [self.serviceImp insertItemInfoList:itemInfoList withSQL:insertDataSQL];
    }
    return NO;
}

/**
 * 插入单条数据model 信息到数据库
 */
- (BOOL)insertItemInfo:(OTAbnormalNetworkDataItem *)itemInfo {
    if (!itemInfo && !itemInfo.itemID.length) {
        return NO;
    }
    NSString *insertDataSQL = [OTAbnormalNetworkDBManager insertDataSQL];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(insertItemInfo:withSQL:)]) {
        return [self.serviceImp insertItemInfo:itemInfo withSQL:insertDataSQL];
    }
    return NO;
}

/**
 * 获取所有数据库model
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchAllItemInfoList {
    NSString *fetchAllSQL = [NSString stringWithFormat:gSQLQueryAllInfo, gOTAbNetInfoDBTableName];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(fetchAllItemInfoListWithSQL:)]) {
        return [self.serviceImp fetchAllItemInfoListWithSQL:fetchAllSQL];
    }
    return nil;
}

/**
 * 获取Limit条记录
 */
- (NSArray<OTAbnormalNetworkDataItem *> *)fetchItemInfoWithLimitCount:(NSUInteger)limitCount;
{
    NSString *limitCountStr = [NSString stringWithFormat:@"%lu", (unsigned long)limitCount];
    NSString *fetchLimitCountSQL = [NSString stringWithFormat:gSQLQueryLimitCountsInfo, gOTAbNetInfoDBTableName, limitCountStr];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(fetchLimitCountItemInfoListWithSQL:)]) {
        return [self.serviceImp fetchLimitCountItemInfoListWithSQL:fetchLimitCountSQL];
    }
    return nil;
}

/**
 * 根据itemId查询item信息
 */
- (OTAbnormalNetworkDataItem *)fetchItemInfoDataWithItemID:(NSString *)itemId {
    NSString *fetchSQL = [NSString stringWithFormat:gSQLQueryInfo, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(fetchItemInfoDataWithItemID:withSQL:)]) {
        return [self.serviceImp fetchItemInfoDataWithItemID:itemId withSQL:fetchSQL];
    }
    return nil;
}
/**
 * 根据itemIDList删除数据
 */
- (BOOL)deleteDataWithItemList:(NSArray<OTAbnormalNetworkDataItem *> *)itemList {
    NSString *deleteSQL = [OTAbnormalNetworkDBManager deleteDataSQL];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(deleteDataWithItemList:withSQL:)]) {
        return [self.serviceImp deleteDataWithItemList:itemList withSQL:deleteSQL];
    }
    return NO;
}

/**
 * 根据单个item数据
 */
- (BOOL)deleteDataWithItem:(OTAbnormalNetworkDataItem *)item {
    NSString *deleteSQL = [OTAbnormalNetworkDBManager deleteDataSQL];
    if (self.serviceImp && [self.serviceImp respondsToSelector:@selector(deleteDataWithItem:withSQL:)]) {
        return [self.serviceImp deleteDataWithItem:item withSQL:deleteSQL];
    }
    return NO;
}

#pragma mark - Helper

/**
 * 删除数据库表
 */
- (BOOL)deleteTableSQL {
    return [NSString stringWithFormat:@"DELETE FROM %@", gOTAbNetInfoDBFileName];
}

+ (NSString *)deleteDataSQL {
    return [NSString stringWithFormat:gSQLDeleteInfo, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId];
    ;
}

+ (NSString *)deleteTableSQL {
    return [NSString stringWithFormat:gSQLDeleteInfo, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId];
}

+ (NSString *)insertDataSQL {
    return [NSString stringWithFormat:gSQLReplaceInfo, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId, gOTAbNetInfoDBColumnExportAPI,
                                      gOTAbNetInfoDBColumnExtraParam, gOTAbNetInfoDBColumnProtoState, gOTAbNetInfoDBColumnDataInfo];
}

+ (NSString *)fetachDataCountSQL {
    return [NSString stringWithFormat:gSQLReplaceInfo, gOTAbNetInfoDBTableName, gOTAbNetInfoDBColumnItemId, gOTAbNetInfoDBColumnExportAPI,
                                      gOTAbNetInfoDBColumnExtraParam, gOTAbNetInfoDBColumnProtoState, gOTAbNetInfoDBColumnDataInfo];
}

+ (NSString *)getDocumentsPath {
    static NSString *pathRet = nil;
    if (!pathRet) {
        // 这里做个优化，一次启动只查找一次, 这个系统查找方法耗时大概 8 毫秒
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            pathRet = (NSString *)[paths objectAtIndex:0];
        }
    }
    return pathRet;
}

@end
