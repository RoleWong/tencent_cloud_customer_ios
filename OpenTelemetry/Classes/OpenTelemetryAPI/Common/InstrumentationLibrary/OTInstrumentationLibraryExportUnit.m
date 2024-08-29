//
//  OTInstrumentationLibraryExportUnit.m
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTInstrumentationLibraryExportUnit.h"

@interface OTInstrumentationLibraryExportUnit ()

@property (nonatomic, strong) OTSafeArray<OTBaseObject<OTJsonConvertible> *> *telemetryData;

@end

@implementation OTInstrumentationLibraryExportUnit

- (instancetype)init {
    if (self = [super init]) {
        _telemetryData = [[OTSafeArray alloc] init];
    }
    return self;
}

- (void)appendTelemetryData:(OTBaseObject<OTJsonConvertible> *)telemetryData {
    [self.telemetryData addObject:telemetryData];
}

#pragma mark - Public

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    NSMutableArray *telemetryJsons = [[NSMutableArray alloc] init];
    [self.telemetryData enumerateObjectsUsingBlock:^(OTBaseObject<OTJsonConvertible> *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *telemetryJson = [obj toJson];
        if (telemetryJson) {
            [telemetryJsons addObject:telemetryJson];
        }
    }];

    [jsonDict setValue:telemetryJsons forKey:self.exportUnitDatasJsonKey];

    NSDictionary *libraryInfoJson = [self.libraryInfo toJson];
    [jsonDict setValue:libraryInfoJson forKey:self.exportUnitJsonKey];

    return jsonDict;
}

+ (NSDictionary<NSString *, OTInstrumentationLibraryExportUnit *> *)createExportUnitsFromTelemetryData:
    (NSArray<OTBaseObject<OTTelemetryDataUnitProtocol> *> *)telemetryData {
    // 构造缓存导出数据的字典
    NSMutableDictionary *instrumentationLibraryInfos = [[NSMutableDictionary alloc] init];
    [telemetryData enumerateObjectsUsingBlock:^(OTBaseObject<OTTelemetryDataUnitProtocol> *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *libarayKey = obj.libraryInfo.key;
        // 读取字典中缓存的导出单位
        OTInstrumentationLibraryExportUnit *exportUint = [instrumentationLibraryInfos objectForKey:libarayKey];
        // 如果没有, 则新建一个导出单位
        if (!exportUint) {
            exportUint = [[OTInstrumentationLibraryExportUnit alloc] init];
            // 赋值导出框架信息
            exportUint.libraryInfo = obj.libraryInfo;
            [instrumentationLibraryInfos setValue:exportUint forKey:libarayKey];
        }
        // 将数据添加到导出单位
        [exportUint appendTelemetryData:obj];
    }];
    return [instrumentationLibraryInfos copy];
}

+ (NSArray *)createJsonFormatDataWithExportUnitCollection:(NSDictionary<NSString *, OTInstrumentationLibraryExportUnit *> *)exportUnits
                                            exportUnitKey:(NSString *)exportUnitKey
                                            exportDataKey:(NSString *)exportDataKey {
    NSMutableArray *exportJsons = [[NSMutableArray alloc] init];
    [exportUnits enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, OTInstrumentationLibraryExportUnit *_Nonnull obj, BOOL *_Nonnull stop) {
        obj.exportUnitJsonKey = exportUnitKey;
        obj.exportUnitDatasJsonKey = exportDataKey;
        NSDictionary *unitJson = [obj toJson];
        [exportJsons addObject:unitJson];
    }];
    return [exportJsons copy];
}

@end
