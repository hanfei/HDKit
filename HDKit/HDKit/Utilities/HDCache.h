//
//  HDCache.h
//  HDKitDemo
//
//  Created by ceo on 9/4/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDCache : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *diretory;

+ (HDCache *)sharedCache;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name directory:(NSString *)directory;

- (id)objectForKey:(NSString *)key;
- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id <NSCopying> object))block;
- (BOOL)objectExistsForKey:(NSString *)key;

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id <NSCopying>)object forKeyedSubscript:(NSString *)key;

- (void)setObject:(id <NSCopying>)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

- (NSString *)pathForKey:(NSString *)key;



@end
