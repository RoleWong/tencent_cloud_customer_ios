//
//  OTValueTypeDefine.h
//  Pods
//
//  Created by ravendeng on 2021/10/18.
//  Copyright (c) 2020 ravendeng. All rights reserved.
//

#ifndef OTValueTypeDefine_h
#define OTValueTypeDefine_h

typedef NS_ENUM(NSUInteger, OTNumericValueType) {
    OTNumericValueTypeLong,
    OTNumericValueTypeDouble,
};

typedef NS_ENUM(NSUInteger, OTInstrumentType) {
    OTInstrumentTypeNone,
    OTInstrumentTypeCounter,
    OTInstrumentTypeObservableCounter,
    OTInstrumentTypeHistogram,
    OTInstrumentTypeObservableGauge,
    OTInstrumentTypeUpDownCounter,
    OTInstrumentTypeObservalbleUpDownCounter,
};

#endif /* OTValueTypeDefine_h */
