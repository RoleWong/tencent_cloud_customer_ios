//
//  OTExemplarFilterProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/11/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef OTExemplarFilterProtocol_h
#define OTExemplarFilterProtocol_h

@class OTMeasurement;
@class OTAttribute;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OTExemplarFilterMode) {
    OTExemplarFilterModeNone,            // do not sample any exemplar at all, default mode
    OTExemplarFilterModeAll,             // collect all measurement as examples
    OTExemplarFilterModeByAttributeKeys, // in this mode, filter will compare the measurement's attributes key and sample them according to wether
                                         // they has the matched attributeKeys property;
    OTExemplarFilterModeByHandlerFilterResultCallback, // in this mode, fillter will call the block and sample measurement according to the
                                                       // filterResulrtCallback property.
    OTExemplarFilterModeByAttributes,                  // filter only sample the mesurements that has exact match attribute key and values
};

typedef BOOL (^OTExemplarFilterResultHandler)(OTMeasurement *measurement);

@protocol OTExemplarFilterProtocol <NSObject>

/// defines how many exemplars each data point can contain, deafault is 1.
@property (nonatomic, assign) NSUInteger maxExemplarsForEachDataPoint;

/// defines what sample mode the filter is taking, see OTExemplarFilterMode
@property (nonatomic, assign) OTExemplarFilterMode mode;

/// user pass an array to tell whether the measurement will converted to exemplar, measurement wich has attribute keys that match the keys in this
/// property will be considered as sampled.
@property (nonatomic, strong) NSArray<NSString *> *attrributeKeys;

/// user pass an array to tell whether the measurement will converted to exemplar, measurements which has attribute match the attributes in this
/// property will be considered as sampled.
@property (nonatomic, strong) NSArray<OTAttribute *> *attributes;

/// user pass an callback block to tell whether the measurement will converted to exemplar
@property (nonatomic, copy) OTExemplarFilterResultHandler filterResultCallback;

/// User should decide which measurement can be return, called by aggregator
/// @param measurement measurement collected by instruments
- (BOOL)shouldSampleMeasurement:(OTMeasurement *)measurement;

@end

NS_ASSUME_NONNULL_END

#endif /* OTExemplarFilterProtocol_h */
