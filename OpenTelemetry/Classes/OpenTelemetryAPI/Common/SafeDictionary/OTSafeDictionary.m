//
//  OTSafeDictionary.m
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/9.
//

#import "OTSafeDictionary.h"

@interface OTSafeDictionary()

{
    NSRecursiveLock *_lock;
    NSMutableDictionary *_dict;
}

@end

@implementation OTSafeDictionary

- (id)init {
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
        _dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [self init];
    if (self) {
        [self addEntriesFromDictionary:dic];
    }
    return self;
}

- (id)initWithMutableDictionary:(NSMutableDictionary *)dic {
    self = [self init];
    if (self) {
        if (dic) {
            [_dict setDictionary:dic];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        NSDictionary *dict = [coder decodeObjectForKey:@"TKPLockDictionary"];
        if (dict) {
            [_dict setDictionary:dict];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSDictionary *dict = [self fetchDictionary];
    [coder encodeObject:dict forKey:@"TKPLockDictionary"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)dealloc {
    _lock = nil;
    _dict = nil;
}

- (void)setDictionary:(NSMutableDictionary *)dic {
    [_lock lock];
    if (_dict) {
        _dict = nil;
    }
    _dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [_lock unlock];
}

- (NSDictionary *)fetchDictionary {
    [_lock lock];

    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_dict];

    [_lock unlock];

    return dict;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    [_lock lock];
    NSDictionary *dic = [self fetchDictionary];
    NSError *error = nil;
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic requiringSecureCoding:YES error:&error];
        NSSet *classSet = [NSSet setWithObjects:NSNumber.class, NSString.class, NSDictionary.class, NSArray.class, nil];
        dic = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:data error:&error];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [_lock unlock];

    BOOL b = [dic writeToFile:path atomically:useAuxiliaryFile];

    return b;
}

- (int)intForKey:(id)aKey {
    return [[self objectForKey:aKey] intValue];
}

- (unsigned long long)unsigedLongLongForKey:(id)aKey {
    return [[self objectForKey:aKey] unsignedLongLongValue];
}

- (id)objectForKey:(id)aKey {
    if (aKey == nil) {
        return nil;
    }
    [_lock lock];
    id obj = [_dict objectForKey:aKey];
    [_lock unlock];
    return obj;
}

- (void)removeObjectForKey:(id)aKey {
    if (aKey == nil) {
        return;
    }

    [_lock lock];
    [_dict removeObjectForKey:aKey];
    [_lock unlock];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        return;
    }

    [_lock lock];
    [_dict setObject:anObject forKey:aKey];
    [_lock unlock];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (key == nil) {
        return;
    }

    [_lock lock];
    [_dict setValue:value forKey:key];
    [_lock unlock];
}

- (id)valueForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }

    [_lock lock];

    id obj = [_dict objectForKey:key];

    [_lock unlock];
    return obj;
}

- (NSString *)stringValueForKey:(id)key {
    NSString *value = [self objectForKey:key];
    if (![value isKindOfClass:[NSString class]]) {
        return @"";
    }
    return value;
}

- (NSArray *)allKeys {
    [_lock lock];
    NSArray *keys = [_dict allKeys];
    [_lock unlock];
    return keys;
}

- (NSArray *)allValues {
    [_lock lock];
    NSArray *values = [_dict allValues];
    [_lock unlock];
    return values;
}

- (NSArray *)allKeysForObject:(id)object {
    [_lock lock];

    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keys = [_dict allKeysForObject:object];
    [arr addObjectsFromArray:keys];
    [_lock unlock];
    return arr;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (!otherDictionary) {
        return;
    }
    [_lock lock];

    NSArray *keyArr = [otherDictionary allKeys];

    for (id key in keyArr) {
        [self setObject:[otherDictionary objectForKey:key] forKey:key];
    }

    [_lock unlock];
}

- (void)removeAllObjects {
    [_lock lock];
    [_dict removeAllObjects];
    [_lock unlock];
}

- (void)removeObjectsForKeys:(NSArray *)keys {
    if (keys == nil) {
        return;
    }

    [_lock lock];
    [_dict removeObjectsForKeys:keys];
    [_lock unlock];
}

- (int)count {
    [_lock lock];
    int count = (int)_dict.count;
    [_lock unlock];

    return count;
}

+ (OTSafeDictionary *)dictionaryWithMutableDictionary:(NSMutableDictionary *)dic {
    OTSafeDictionary *lockDic = [[OTSafeDictionary alloc] initWithMutableDictionary:dic];
    return lockDic;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void(NS_NOESCAPE ^)(id _Nonnull key, id _Nonnull obj, BOOL *stop))block {
    [_lock lock];
    [_dict enumerateKeysAndObjectsUsingBlock:block];
    [_lock unlock];
}

- (NSString *)description {
    NSString *description = @"";
    [_lock lock];
    description = _dict.description;
    [_lock unlock];

    return description;
}

@end
