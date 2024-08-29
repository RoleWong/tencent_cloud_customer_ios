//
//  Link.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/26.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTLink.h"
#import "OTAttributesWithCapacity.h"
#import "OTSpanContext.h"
#import "OTTraceId.h"
#import "OTSpanId.h"
#import "OTTraceState.h"
#import "OTSpanDataReportKeys.h"

@interface OTLink ()

{
    OTAttributesWithCapacity *_attributesCollection;
}

@property (nonatomic, strong) id<OTContextProtocol> context;

@end

@implementation OTLink

- (instancetype)initWithSpanContext:(id<OTContextProtocol>)context attributes:(NSArray<OTAttribute *> *)attributes capacity:(NSInteger)capactiy {
    self = [super init];
    if (self) {
        _context = context;
        _attributesCollection = [[OTAttributesWithCapacity alloc] initWithCapacity:capactiy];
        [_attributesCollection updateAttributes:attributes];
    }
    return self;
}

- (NSArray<OTAttribute *> *)attributes {
    return _attributesCollection.attributes;
}

- (NSArray<NSDictionary *> *)attributesInJsonForm {
    NSMutableArray *attributeJsons = [[NSMutableArray alloc] init];
    [[self attributes] enumerateObjectsUsingBlock:^(OTAttribute *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *attributeJson = [obj toJson];
        [attributeJsons addObject:attributeJson];
    }];
    return attributeJsons;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSString *traceId = self.context.traceIdString;
    NSString *spanId = self.context.spanIdString;
    NSString *traceState = self.context.traceStateString;
    [json setValue:traceId forKey:OTSpanDataKeyTraceId];
    [json setValue:spanId forKey:OTSpanDataKeySpanId];
    [json setValue:[self attributesInJsonForm] forKey:OTSpanDataKeyAttributes];
    [json setValue:@(_attributesCollection.droppedCount) forKey:OTSpanDroppedAttributesKey];
    [json setValue:traceState forKey:OTSpanDataKeyTraceState];
    return json;
}

@end
