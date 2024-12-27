//
//  OTReadableSpan.h
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTSpan.h"
#import "OTSpanProcessorProtocol.h"
#import "OTClockProtocol.h"

@class OTSpanId;
@class OTInstrumentationLibraryInfo;

NS_ASSUME_NONNULL_BEGIN

@interface OTReadableSpan : OTSpan

@property (nonatomic, assign) NSInteger maximumAttributesPerEvent;
@property (nonatomic, assign) NSInteger maximumAttributesPerLink;
@property (nonatomic, assign) NSInteger maximumAttributes;
@property (nonatomic, assign) NSInteger maximumLinks;
@property (nonatomic, assign) NSInteger maximumEvents;

- (instancetype)initWithContext:(OTSpanContext *)context name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
