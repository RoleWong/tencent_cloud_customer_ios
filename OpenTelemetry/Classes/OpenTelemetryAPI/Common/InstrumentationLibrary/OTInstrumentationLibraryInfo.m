//
//  InstrumentationLibraryInfo.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/5/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTInstrumentationLibraryInfo.h"

@interface OTInstrumentationLibraryInfo()

/// 测量模式的名称
@property (nonatomic, copy, readwrite) NSString *name;

/// 测量模式的版本
@property (nonatomic, copy, readwrite) NSString *version;

@end

@implementation OTInstrumentationLibraryInfo

- (instancetype)initWithName:(NSString *)name version:(NSString *)version {
    if (self = [super init]) {
        self.name = name;
        self.version = version;
    }
    return self;
}

- (NSString *)key {
    // 根据名称和版本号区别测量框架
    return [NSString stringWithFormat:@"%@_%@", self.name, self.version];
}

- (BOOL)isequalToLibraryInfo:(OTInstrumentationLibraryInfo *)info {
    BOOL sameName = [self.name isEqualToString:info.name];
    BOOL sameVersion = [self.version isEqualToString:info.version];
    return sameName && sameVersion;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    
    [jsonDict setValue:self.version forKey:@"version"];
    [jsonDict setValue:self.name forKey:@"name"];
    
    return jsonDict;
}

@end
