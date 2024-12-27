//
//  OTSafeArray.m
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/9.
//

#import "OTSafeArray.h"

@interface OTSafeArray()

{
    NSRecursiveLock *_lock;
    NSMutableArray *_array;
}

@end

@implementation OTSafeArray

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithNSMutableArray:(NSMutableArray *)array {
    self = [self init];
    if (self) {
        if (array) {
            [_array setArray:array];
        }
    }
    return self;
}

- (id)initWithNSArray:(NSArray *)array {
    self = [self init];
    if (self) {
        if (array) {
            [self addObjectsFromArray:array];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        NSArray *array = [coder decodeObjectForKey:@"OTSafeArray"];
        if (array) {
            [_array setArray:array];
        }
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSArray *array = [self fetchArray];
    [coder encodeObject:array forKey:@"OTSafeArray"];
}

- (id)objectAtIndex:(NSUInteger)index {
    [_lock lock];
    id anObject = nil;
    if (index >= 0 && index < self.count) {
        anObject = [_array objectAtIndex:index];
    }
    [_lock unlock];
    return anObject;
}

- (NSUInteger)indexOfObject:(id)obj {
    [_lock lock];
    NSUInteger index = [_array indexOfObject:obj];
    [_lock unlock];
    return index;
}

- (void)addObject:(id)anObject {
    [_lock lock];
    [_array addObject:anObject];
    [_lock unlock];
}

- (void)setArray:(NSArray *)array {
    [_lock lock];
    _array = [[NSMutableArray alloc] initWithArray:array];
    [_lock unlock];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_lock lock];
    [_array insertObject:anObject atIndex:index];
    [_lock unlock];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    if (!otherArray) {
        return;
    }
    [_lock lock];
    [_array addObjectsFromArray:otherArray];
    [_lock unlock];
}

- (void)addObjectsFromArrayDeduplicated:(NSArray *)otherArray {
    if (otherArray.count == 0) {
        return;
    }
    [_lock lock];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (id obj in otherArray) {
        if ([self containsObject:obj]) {
            continue;
        }
        [tempArray addObject:obj];
    }
    [_lock unlock];
    [self addObjectsFromArray:tempArray];
}

- (void)removeObject:(id)anObject {
    [_lock lock];
    [_array removeObject:anObject];
    [_lock unlock];
}

- (void)removeLastObject {
    [_lock lock];
    [_array removeLastObject];
    [_lock unlock];
}

- (void)removeAllObjects {
    [_lock lock];
    [_array removeAllObjects];
    [_lock unlock];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_lock lock];
    if (index < _array.count) {
        [_array removeObjectAtIndex:index];
    }
    [_lock unlock];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_lock lock];
    [_array replaceObjectAtIndex:index withObject:anObject];
    [_lock unlock];
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    [_lock lock];
    [_array removeObjectsInArray:otherArray];
    [_lock unlock];
}

- (NSArray *)fetchArray {
    [_lock lock];
    NSArray *array = [NSArray arrayWithArray:_array];
    [_lock unlock];
    return array;
}

- (NSUInteger)count {
    return _array.count;
}

- (void)enumerateObjectsUsingBlock:(void(NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_lock lock];
    [_array enumerateObjectsUsingBlock:block];
    [_lock unlock];
}

- (NSArray *)subarrayWithRange:(NSRange)range deleteOption:(BOOL)shouldDelete {
    [_lock lock];
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location >= [self count] || length <= 0) {
        [_lock unlock];
        return nil;
    }
    NSArray *array = nil;
    NSUInteger safeLength = MIN(length, [self count] - location);
    NSRange safeRange = NSMakeRange(location, safeLength);
    if (location < self.count && length > 0) {
        array = [_array subarrayWithRange:safeRange];
    }
    if (shouldDelete && array) {
        [_array removeObjectsInRange:safeRange];
    }
    [_lock unlock];
    return array;
}

- (id)firstObject {
    [_lock lock];
    id anObject = _array.firstObject;
    [_lock unlock];
    return anObject;
}

- (id)lastObject {
    [_lock lock];
    id anObject = _array.lastObject;
    [_lock unlock];
    return anObject;
}

- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    [_lock lock];
    [_array sortUsingComparator:cmptr];
    [_lock unlock];
}

- (BOOL)containsObject:(id)object {
    [_lock lock];
    BOOL isContain = [_array containsObject:object];
    [_lock unlock];
    return isContain;
}

- (NSString *)description {
    NSString *description = @"";
    [_lock lock];
    description = _array.description;
    [_lock unlock];

    return description;
}

@end
