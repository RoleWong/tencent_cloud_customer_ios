//
//  OTSafeArray.h
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSafeArray<T> : NSObject <NSCoding, NSSecureCoding>

- (id)initWithNSMutableArray:(NSMutableArray *)array;
- (id)initWithNSArray:(NSArray *)array;
- (id _Nullable)objectAtIndex:(NSUInteger)index;
- (void)addObject:(T)anObject;
- (void)setArray:(NSArray *)array;
- (void)insertObject:(T)anObject atIndex:(NSUInteger)index;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)addObjectsFromArrayDeduplicated:(NSArray *)otherArray;
- (void)removeObject:(T)anObject;
- (void)removeLastObject;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(T)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (NSArray *)fetchArray;
- (NSUInteger)count;
- (void)enumerateObjectsUsingBlock:(void(NS_NOESCAPE ^)(T obj, NSUInteger idx, BOOL *stop))block;
- (NSArray *_Nullable)subarrayWithRange:(NSRange)range deleteOption:(BOOL)shouldDelete;
- (T)firstObject;
- (T)lastObject;
- (NSUInteger)indexOfObject:(T)obj;
- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr;
- (BOOL)containsObject:(T)object;

@end

NS_ASSUME_NONNULL_END
