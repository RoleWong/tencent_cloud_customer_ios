//
//  NSObject+OTPerformAdditions.h
//  OpenTelemetry
//
//  Created by huanfeima on 2024/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OTPerformAdditions)
/**
 * Additional performSelector signatures that support up to 7 arguments.
 * remove warnning of nsobject's performselector
 */
- (id)ot_utPerformSelector:(SEL)selector;

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1;

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2;

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

- (id)ot_utPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

@end

NS_ASSUME_NONNULL_END
