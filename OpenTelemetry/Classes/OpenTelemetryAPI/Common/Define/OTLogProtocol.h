//
//  OTLogProtocol.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OTLogProtocol <NSObject>
/**
 * Debug级别打印日志
 * @param fileName 文件名称
 * @param lineNumber 行号
 * @param function 函数名称
 * @param tag 标记
 * @param format 内容
 */
- (void)d:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;
/**
 * Info级别打印日志,会写入文件存储
 * @param fileName 文件名称
 * @param lineNumber 行号
 * @param function 函数名称
 * @param tag 标记
 * @param format 内容
 */
- (void)i:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;
/**
 * Error级别打印日志,会写入文件存储
 * @param fileName 文件名称
 * @param lineNumber 行号
 * @param function 函数名称
 * @param tag 标记
 * @param format 内容
 */
- (void)e:(const char *)fileName lineNumber:(int)lineNumber function:(const char *)function tag:(NSString *)tag format:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
