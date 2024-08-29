//
//  OTInstrumentationLibraryExportUnit.h
//  OpenTelemetry
//
//  Created by ravendeng on 2022/4/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "OTJsonConvertible.h"
#import "OTSafeArray.h"
#import "OTInstrumentationLibraryInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTInstrumentationLibraryExportUnit : OTBaseObject <OTJsonConvertible>

/// the key used by export Uint to form JsonData
@property (nonatomic, copy) NSString *exportUnitJsonKey;

/// the key used by export Uint datas to form JsonData
@property (nonatomic, copy) NSString *exportUnitDatasJsonKey;

/// insrutmentdationlibraryinfos for these spans
@property (nonatomic, strong) OTInstrumentationLibraryInfo *libraryInfo;

/// telemetry datas
@property (nonatomic, strong, readonly) OTSafeArray<OTBaseObject<OTJsonConvertible> *> *telemetryData;

/// append a telemetry data
/// @param telemetryData telemetryData
- (void)appendTelemetryData:(OTBaseObject<OTJsonConvertible> *)telemetryData;

/// create an export uint array in helping data export
/// @param telemetryData telemetryData
+ (NSDictionary<NSString *, OTInstrumentationLibraryExportUnit *> *)createExportUnitsFromTelemetryData:
    (NSArray<OTBaseObject<OTTelemetryDataUnitProtocol> *> *)telemetryData;

/// create data in json format to export telemetryData
/// @param exportUnits export unit collection in Dictionary format
/// @param exportUnitKey data key for export unit
/// @param exportDataKey data key for each telemetry data in a single unit
+ (NSArray *)createJsonFormatDataWithExportUnitCollection:(NSDictionary<NSString *, OTInstrumentationLibraryExportUnit *> *)exportUnits
                                            exportUnitKey:(NSString *)exportUnitKey
                                            exportDataKey:(NSString *)exportDataKey;

@end

NS_ASSUME_NONNULL_END
