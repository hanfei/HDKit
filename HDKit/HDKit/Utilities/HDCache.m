//
//  HDCache.m
//  HDKitDemo
//
//  Created by ceo on 9/4/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "HDCache.h"

@interface HDCache ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) dispatch_queue_t callbackQueue;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation HDCache

- (NSCache *)cache {
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

- (instancetype)init {
    NSLog(@"[HDCache] You must initalize HDCache using `initWithName:`");
    return nil;
}

- (void)dealloc {
    [self.cache removeAllObjects];
}

+ (HDCache *)sharedCache {
    static HDCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[HDCache alloc] initWithName:@"com.harvey.hdcache.shared" directory:nil];
    });
    return sharedCache;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name directory:nil];
}

- (instancetype)initWithName:(NSString *)name directory:(NSString *)directory {
    if (self = [super init]) {
        self.name = name;
        self.cache.name = name;
        _callbackQueue = dispatch_queue_create([[name stringByAppendingString:@".callback"] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
        _ioQueue = dispatch_queue_create([[name stringByAppendingString:@".disk"] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
        
        if (!directory) {
            NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            directory = [cacheDirectory stringByAppendingFormat:@"/com.harvey.hdcache/%@",_name];
        }
        _directory = directory;
        
        if ([self.fileManager fileExistsAtPath:_directory]) {
            NSError *error;
            [self.fileManager createDirectoryAtPath:_directory
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:&error];
            if (error) {
                NSLog(@"Failed to create cache directory: %@",error);
            }else {
                [self _exclueFileFromBackup:[NSURL fileURLWithPath:self.directory]];
            }
        }
    }
    return self;
}


- (id)objectForKey:(NSString *)key {
    __block id object = [self.cache objectForKey:key];
    if (object) {
        return object;
    }
    
    NSString *path = [self pathForKey:key];
    if (!path) {
        return nil;
    }
    
    dispatch_sync(self.ioQueue, ^{
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!object) {
            return;
        }
    });
    
    if (object) {
        [self.cache setObject:object forKey:key];
    }
    
    return object;
}

- (void)objectForKey:(NSString *)key usingBlock:(void (^)(id<NSCopying>))block {
    dispatch_async(self.callbackQueue, ^{
        block([self objectForKey:key]);
    });
}

- (BOOL)objectExistsForKey:(NSString *)key {
    __block BOOL exist = [self.cache objectForKey:key] != nil;
    if (exist) {
        return YES;
    }
    
    dispatch_sync(self.ioQueue, ^{
        exist = [self.fileManager fileExistsAtPath:[self _pathForKey:key]];
    });
    
    return exist;
}

- (void)setObject:(id<NSCopying>)object forKey:(NSString *)key {
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    [self.cache setObject:object forKey:key];
    
    dispatch_async(self.ioQueue, ^{
        NSString *path = [self _pathForKey:key];
        if ([NSKeyedArchiver archiveRootObject:object toFile:path]) {
            [self _exclueFileFromBackup:[NSURL fileURLWithPath:path]];
        }
    });
}

- (void)removeObjectForKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
    dispatch_async(self.ioQueue, ^{
        [self.fileManager removeItemAtPath:[self _pathForKey:key] error:NULL];
    });
}

- (void)removeAllObjects {
    [self.cache removeAllObjects];
    dispatch_async(self.ioQueue, ^{
        for (NSString *path in [self.fileManager contentsOfDirectoryAtPath:self.directory error:NULL]) {
            [self.fileManager removeItemAtPath:[self.directory stringByAppendingPathComponent:path] error:NULL];
        }
        [self.fileManager removeItemAtPath:self.directory error:NULL];
    });
}

- (NSString *)pathForKey:(NSString *)key {
    if ([self objectExistsForKey:key]) {
        return [self _pathForKey:key];
    }
    return nil;
}


- (NSString *)_sanitizeFielNameString:(NSString *)filename {
    static NSCharacterSet *illegalFileNameCharacters = nil;
    static dispatch_once_t illegalCharacterCreationToken;
    dispatch_once(&illegalCharacterCreationToken, ^{
        illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"\\?%*|\"<>:"];
    });
    return [[filename componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

- (NSString *)_pathForKey:(NSString *)key {
    key = [self _sanitizeFielNameString:key];
    return [self.directory stringByAppendingPathComponent:key];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self objectForKey:key];
}

- (void)setObject:(id<NSCopying>)object forKeyedSubscript:(NSString *)key {
    [self setObject:object forKey:key];
}

- (BOOL)_exclueFileFromBackup:(NSURL *)fileUrl {
    NSError *error;
    BOOL result = [fileUrl setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"Failed to exclude file from backup: %@",error);
    }
    return result;
}






















@end
