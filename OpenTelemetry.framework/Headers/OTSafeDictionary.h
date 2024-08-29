//
//  OTSafeDictionary.h
//  Pods-OpenTelemetry_Example
//
//  Created by ravendeng on 2021/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSafeDictionary<Key, Value> : NSObject <NSCoding, NSSecureCoding>

- (id)initWithDictionary:(NSDictionary *)dic;
- (id)initWithMutableDictionary:(NSMutableDictionary *)dic;
- (int)intForKey:(Key)aKey;
- (unsigned long long)unsigedLongLongForKey:(Key)aKey;
- (Value)objectForKey:(Key)aKey;
- (void)removeObjectForKey:(Key)aKey;
- (void)setObject:(Value)anObject forKey:(Key<NSCopying>)aKey;
- (void)setValue:(nullable Value)value forKey:(NSString *)key;
- (Value)valueForKey:(NSString *)key;
- (NSString *)stringValueForKey:(Key)key;
- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSArray *)allKeysForObject:(Value)object;
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keys;
- (int)count;
- (void)setDictionary:(NSMutableDictionary *)dic;
- (NSDictionary *)fetchDictionary;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

+ (OTSafeDictionary *)dictionaryWithMutableDictionary:(NSMutableDictionary *)dic;

- (void)enumerateKeysAndObjectsUsingBlock:(void(NS_NOESCAPE ^)(Key key, Value obj, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
