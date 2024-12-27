//
//  OTLogImpl.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import <Foundation/Foundation.h>
#import "OTLogProtocol.h"

#define OTLogD(fmt, ...)                                                                                                            \
    do {                                                                                                                            \
        [OTLogImpl d:__FILE_NAME__ lineNumber:__LINE__ function:__func__ tag:@"[OTOpenTelemetry DEBUG]" format:fmt, ##__VA_ARGS__]; \
    } while (0)

#define OTLogI(fmt, ...)                                                                                                           \
    do {                                                                                                                           \
        [OTLogImpl i:__FILE_NAME__ lineNumber:__LINE__ function:__func__ tag:@"[OTOpenTelemetry INFO]" format:fmt, ##__VA_ARGS__]; \
    } while (0)

#define OTLogE(fmt, ...)                                                                                                            \
    do {                                                                                                                            \
        [OTLogImpl e:__FILE_NAME__ lineNumber:__LINE__ function:__func__ tag:@"[OTOpenTelemetry ERROR]" format:fmt, ##__VA_ARGS__]; \
    } while (0)

NS_ASSUME_NONNULL_BEGIN

@interface OTLogImpl : NSObject

+ (void)injectInstance:(id<OTLogProtocol>)instance;

+ (void)d:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

+ (void)i:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

+ (void)e:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
