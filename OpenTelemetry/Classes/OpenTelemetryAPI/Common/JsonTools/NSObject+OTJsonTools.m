//
//  NSObject+OTJsonTools.m
//  OpenTelemetry
//
//  Created by ravendeng on 2021/10/1.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NSObject+OTJsonTools.h"

@implementation NSObject (OTJsonTools)

- (NSString *)ot_jsonStringWithError:(NSError **)error {
    NSString *resultString = @"";
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:error];
        resultString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return resultString;
}

- (NSString *)ot_jsonStringOnelineWithError:(NSError **)error {
    NSString *resultString = @"";
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:error];
        resultString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return resultString;
}

@end
