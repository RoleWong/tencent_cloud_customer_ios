//
//  NSString+OTUtility.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/24.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NSString+OTUtility.h"

static NSInteger const kMininumHexStringLength = 2;

@implementation NSString (OTUtility)

#pragma mark - Public

- (NSUInteger)ot_numberWithHexString {
    const char *hexCString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexCString, "%x", &hexNumber);
    return (NSUInteger)hexNumber;
}

- (NSString *)ot_base64StringFromHexString {
    NSData *hexData = [NSString ot_dataFromHexadecimalString:self];
    return [hexData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)ot_hexStringFromBase64String {
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [NSString ot_convertDataToHexStr:base64Data];
}

#pragma mark - Private

+ (NSData *)ot_dataFromHexadecimalString:(NSString *)hexString {
    // in case the hexadecimal string is from `NSData` description method (or `stringWithFormat`), eliminate
    // any spaces, `<` or `>` characters
    if (hexString.length == 0) {
        return nil;
    }
    while (hexString.length < kMininumHexStringLength || hexString.length % 2 != 0) {
        hexString = [@"0" stringByAppendingString:hexString];
    }
    
    NSString *hexadecimalString = [hexString stringByReplacingOccurrencesOfString:@"[ <>]"
                                                                       withString:@""
                                                                          options:NSRegularExpressionSearch
                                                                            range:NSMakeRange(0, [hexString length])];

    NSMutableData *data = [NSMutableData dataWithCapacity:[hexadecimalString length] / 2];
    for (NSInteger i = 0; i < [hexadecimalString length]; i += 2) {
        NSString *hexChar = [hexadecimalString substringWithRange:NSMakeRange(i, kMininumHexStringLength)];
        int value;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        uint8_t byte = value;
        [data appendBytes:&byte length:1];
    }

    return data;
}

+ (NSString *)ot_convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char *)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

#pragma mark - load function

void loadOTUtilltyMethods(void) {
    printf("NSString+OTUtility loaded");
}

@end
