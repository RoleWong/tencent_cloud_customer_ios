//
//  InstrumentationLibraryInfo.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTBaseObject.h"
#import "OTJsonConvertible.h"

NS_ASSUME_NONNULL_BEGIN

/// recorded the information of the instrumentation library which is using the openTelemetry sdk
@interface OTInstrumentationLibraryInfo : OTBaseObject <OTJsonConvertible>

/// name of the instrumentation library
@property (nonatomic, copy, readonly) NSString *name;

/// version of the instrumentation library
@property (nonatomic, copy, readonly) NSString *version;

/// schema url
@property (nonatomic, copy) NSString *schemaUrl;

/// init an intrfumenttation library info
/// @param name name description
/// @param version version description
- (instancetype)initWithName:(NSString *)name version:(NSString *)version;

/// unique key of the info
- (NSString *)key;

/// return wether an instrumentation library info is equal to another
/// @param info info description
- (BOOL)isequalToLibraryInfo:(OTInstrumentationLibraryInfo *)info;

@end

NS_ASSUME_NONNULL_END
