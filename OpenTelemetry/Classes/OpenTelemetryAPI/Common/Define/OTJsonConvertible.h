//
//  OTJsonConvertible.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/6/30.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef OTJsonConvertible_h
#define OTJsonConvertible_h

@class OTInstrumentationLibraryInfo;

@protocol OTJsonConvertible <NSObject, NSCoding, NSSecureCoding>

- (NSDictionary *)toJson;

@end

@protocol OTTelemetryDataUnitProtocol <OTJsonConvertible>

@property (nonatomic, copy, readonly) OTInstrumentationLibraryInfo *libraryInfo;

@end

#endif /* OTJsonConvertible_h */
