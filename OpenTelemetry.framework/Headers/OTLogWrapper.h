//
//  OTLogWrapper.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTLogWrapper : NSObject

+ (instancetype)sharedInstance;

/**
 * Debug 级别 带字符串模版输出日志
 *
 * @param fileName    所在文件
 * @param lineNumber    所在代码行
 * @param function 所在方法名
 * @param tag    日志标签
 */
- (void)d:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

/**
 * Info 级别 输出日志
 *
 * @param fileName    所在文件
 * @param lineNumber    所在代码行
 * @param function 所在方法名
 * @param tag    日志标签
 */
- (void)i:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

/**
 * Warn 级别 输出日志
 *
 * @param fileName    所在文件
 * @param lineNumber    所在代码行
 * @param function 所在方法名
 * @param tag    日志标签
 */
- (void)w:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

/**
 * Error 级别 输出日志
 *
 * @param fileName    所在文件
 * @param lineNumber    所在代码行
 * @param function 所在方法名
 * @param tag    日志标签
 */
- (void)e:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
