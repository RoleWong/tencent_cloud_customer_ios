//
//  OTLogImpl.m
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import "OTLogImpl.h"

static id<OTLogProtocol> gOTLogImpl = nil;

@implementation OTLogImpl

+ (void)injectInstance:(id<OTLogProtocol>)instance {
    gOTLogImpl = instance;
}

+ (void)d:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:args];
    if ([gOTLogImpl respondsToSelector:@selector(d:lineNumber:function:tag:format:)]) {
        [gOTLogImpl d:fileName lineNumber:lineNumber function:function tag:tag format:formatStr];
    }
    va_end(args);
}

+ (void)i:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:args];
    if ([gOTLogImpl respondsToSelector:@selector(i:lineNumber:function:tag:format:)]) {
        [gOTLogImpl i:fileName lineNumber:lineNumber function:function tag:tag format:formatStr];
    }
    va_end(args);
}

+ (void)e:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:args];
    if ([gOTLogImpl respondsToSelector:@selector(e:lineNumber:function:tag:format:)]) {
        [gOTLogImpl e:fileName lineNumber:lineNumber function:function tag:tag format:formatStr];
    }
    va_end(args);
}

@end
