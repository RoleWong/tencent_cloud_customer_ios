//
//  OTInstrumentBuilder.h
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTInstrument.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTInstrumentBuilder : NSObject

- (OTInstrumentBuilder *)configType:(OTInstrumentType)type;

- (OTInstrumentBuilder *)configValueType:(OTNumericValueType)valueType;

- (OTInstrumentBuilder *)configName:(NSString *)name;

- (OTInstrumentBuilder *)configUnit:(NSString *)unit;

- (OTInstrumentBuilder *)configDescription:(NSString *)description;

- (OTInstrument *)build;

@end

NS_ASSUME_NONNULL_END
