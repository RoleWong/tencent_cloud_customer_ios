//
//  OTLogWrapper.m
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import "OTLogWrapper.h"
// #import <VBLogServiceiOS/VBLog.h>
// #import <VBLogServiceiOS/VBLogCongfig.h>

@implementation OTLogWrapper

+ (instancetype)sharedInstance {
    static OTLogWrapper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//- (nonnull VBLog *)getOTVBLog {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (![VBLog getInstance]) {
//            [VBLog initWithConfig:[VBLogCongfig defalutConfig]];
//        }
//    });
//    return [VBLog getInstance];
//}
//
//- (void)d:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
//    va_list args;
//    va_start(args, format);
//    NSString *fromatString = [[NSString alloc] initWithFormat:format arguments:args];
//    [[self getOTVBLog] d:fileName lineNumber:lineNumber function:function tag:tag format:fromatString];
//    va_end(args);
//}
//
//- (void)i:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
//    va_list args;
//    va_start(args, format);
//    NSString *fromatString = [[NSString alloc] initWithFormat:format arguments:args];
//    [[self getOTVBLog] i:fileName lineNumber:lineNumber function:function tag:tag format:fromatString];
//    va_end(args);
//}
//
//- (void)w:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
//    va_list args;
//    va_start(args, format);
//    NSString *fromatString = [[NSString alloc] initWithFormat:format arguments:args];
//    [[self getOTVBLog] w:fileName lineNumber:lineNumber function:function tag:tag format:fromatString];
//    va_end(args);
//}
//
//- (void)e:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
//    va_list args;
//    va_start(args, format);
//    NSString *fromatString = [[NSString alloc] initWithFormat:format arguments:args];
//    [[self getOTVBLog] e:fileName lineNumber:lineNumber function:function tag:tag format:fromatString];
//    va_end(args);
//}
@end
