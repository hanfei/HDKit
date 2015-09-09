//
//  HDKeychain.m
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "HDKeychain.h"
#import "UIDevice+HDKit.h"
#import <Security/Security.h>

static HDKeychainErrorCode HDKeychainErrorCodeFromOSStatus(OSStatus status) {
    switch (status) {
        case errSecUnimplemented: return HDKeychainErrorUnimplemented;
        case errSecIO: return HDKeychainErrorIO;
        case errSecOpWr: return HDKeychainErrorOpWr;
        case errSecParam: return HDKeychainErrorParam;
        case errSecAllocate: return HDKeychainErrorAllocate;
        case errSecUserCanceled: return HDKeychainErrorUserCanceled;
        case errSecBadReq: return HDKeychainErrorBadReq;
        case errSecInternalComponent: return HDKeychainErrorInternalComponent;
        case errSecNotAvailable: return HDKeychainErrorNotAvailable;
        case errSecDuplicateItem: return HDKeychainErrorDuplicateItem;
        case errSecItemNotFound: return HDKeychainErrorItemNotFound;
        case errSecInteractionNotAllowed: return HDKeychainErrorInteractionNotAllowed;
        case errSecDecode: return HDKeychainErrorDecode;
        case errSecAuthFailed: return HDKeychainErrorAuthFailed;
        default: return 0;
    }
}

static NSString *HDKeychainErrorDesc(HDKeychainErrorCode code) {
    switch (code) {
        case HDKeychainErrorUnimplemented:
            return @"Function or operation not implemented.";
        case HDKeychainErrorIO:
            return @"I/O error (bummers)";
        case HDKeychainErrorOpWr:
            return @"ile already open with with write permission.";
        case HDKeychainErrorParam:
            return @"One or more parameters passed to a function where not valid.";
        case HDKeychainErrorAllocate:
            return @"Failed to allocate memory.";
        case HDKeychainErrorUserCanceled:
            return @"User canceled the operation.";
        case HDKeychainErrorBadReq:
            return @"Bad parameter or invalid state for operation.";
        case HDKeychainErrorInternalComponent:
            return @"Inrernal Component";
        case HDKeychainErrorNotAvailable:
            return @"No keychain is available. You may need to restart your computer.";
        case HDKeychainErrorDuplicateItem:
            return @"The specified item already exists in the keychain.";
        case HDKeychainErrorItemNotFound:
            return @"The specified item could not be found in the keychain.";
        case HDKeychainErrorInteractionNotAllowed:
            return @"User interaction is not allowed.";
        case HDKeychainErrorDecode:
            return @"Unable to decode the provided data.";
        case HDKeychainErrorAuthFailed:
            return @"The user name or passphrase you entered is not";
        default:
            break;
    }
    return nil;
}

static NSString *HDKeychainAccessibleStr(HDKeychainAccessible e) {
    switch (e) {
        case HDKeychainAccessibleWhenUnlocked:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlocked);
        case HDKeychainAccessibleAfterFirstUnlock:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlock);
        case HDKeychainAccessibleAlways:
            return (__bridge NSString *)(kSecAttrAccessibleAlways);
        case HDKeychainAccessibleWhenPasscodeSetThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly);
        case HDKeychainAccessibleWhenUnlockedThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
        case HDKeychainAccessibleAfterFirstUnlockThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
        case HDKeychainAccessibleAlwaysThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAlwaysThisDeviceOnly);
        default:
            return nil;
    }
}

static HDKeychainAccessible HDKeychainAccessibleEnum(NSString *s) {
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlocked])
        return HDKeychainAccessibleWhenUnlocked;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock])
        return HDKeychainAccessibleAfterFirstUnlock;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlways])
        return HDKeychainAccessibleAlways;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly])
        return HDKeychainAccessibleWhenPasscodeSetThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly])
        return HDKeychainAccessibleWhenUnlockedThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly])
        return HDKeychainAccessibleAfterFirstUnlockThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly])
        return HDKeychainAccessibleAlwaysThisDeviceOnly;
    return HDKeychainAccessibleNone;
}

static id HDKeychainQuerySynchonizationID(HDKeychainQuerySynchronizationMode mode) {
    switch (mode) {
        case HDKeychainQuerySynchronizationModeAny:
            return (__bridge id)(kSecAttrSynchronizableAny);
        case HDKeychainQuerySynchronizationModeNo:
            return @(NO);
        case HDKeychainQuerySynchronizationModeYes:
            return @(YES);
        default:
            return (__bridge id)(kSecAttrSynchronizableAny);
    }
}

static HDKeychainQuerySynchronizationMode HDKeychainQuerySynchonizationEnum(NSNumber *num) {
    if ([num isEqualToNumber:@NO]) return HDKeychainQuerySynchronizationModeNo;
    if ([num isEqualToNumber:@YES]) return HDKeychainQuerySynchronizationModeYes;
    return HDKeychainQuerySynchronizationModeAny;
}

@interface HDKeychainItem ()
@property (nonatomic, readwrite, copy) NSDate *modificationDate;
@property (nonatomic, readwrite, copy) NSDate *creationDate;
@end

@implementation HDKeychainItem


- (void)setPasswordObject:(id <NSCoding> )object {
    self.passwordData = [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id <NSCoding> )passwordObject {
    if ([self.passwordData length]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.passwordData];
    }
    return nil;
}

- (void)setPassword:(NSString *)password {
    self.passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)password {
    if ([self.passwordData length]) {
        return [[NSString alloc] initWithData:self.passwordData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSMutableDictionary *)dic {
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (self.account) dic[(__bridge id)kSecAttrAccount] = self.account;
    if (self.service) dic[(__bridge id)kSecAttrService] = self.service;
    if (self.label) dic[(__bridge id)kSecAttrLabel] = self.label;
    
    if (![[UIDevice currentDevice] isSimulator]) {
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        if (self.accessGroup) dic[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if (HDSystemVersionAboveOrIs(@"7.0")) {
        dic[(__bridge id)kSecAttrSynchronizable] = HDKeychainQuerySynchonizationID(self.synchronizable);
    }
    
    if (self.accessible) dic[(__bridge id)kSecAttrAccessible] = HDKeychainAccessibleStr(self.accessible);
    if (self.passwordData) dic[(__bridge id)kSecValueData] = self.passwordData;
    if (self.type) dic[(__bridge id)kSecAttrType] = self.type;
    if (self.creater) dic[(__bridge id)kSecAttrCreator] = self.creater;
    if (self.comment) dic[(__bridge id)kSecAttrComment] = self.comment;
    if (self.descr) dic[(__bridge id)kSecAttrDescription] = self.descr;
    
    return dic;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = self.init;
    
    self.service = dic[(__bridge id)kSecAttrService];
    self.account = dic[(__bridge id)kSecAttrAccount];
    self.passwordData = dic[(__bridge id)kSecValueData];
    self.label = dic[(__bridge id)kSecAttrLabel];
    self.type = dic[(__bridge id)kSecAttrType];
    self.creater = dic[(__bridge id)kSecAttrCreator];
    self.comment = dic[(__bridge id)kSecAttrComment];
    self.descr = dic[(__bridge id)kSecAttrDescription];
    self.modificationDate = dic[(__bridge id)kSecAttrModificationDate];
    self.creationDate = dic[(__bridge id)kSecAttrCreationDate];
    self.accessGroup = dic[(__bridge id)kSecAttrAccessGroup];
    self.accessible = HDKeychainAccessibleEnum(dic[(__bridge id)kSecAttrAccessible]);
    self.synchronizable = HDKeychainQuerySynchonizationEnum(dic[(__bridge id)kSecAttrSynchronizable]);
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HDKeychainItem *item = [HDKeychainItem new];
    item.service = self.service;
    item.account = self.account;
    item.passwordData = self.passwordData;
    item.label = self.label;
    item.type = self.type;
    item.creater = self.creater;
    item.comment = self.comment;
    item.descr = self.descr;
    item.modificationDate = self.modificationDate;
    item.creationDate = self.creationDate;
    item.accessGroup = self.accessGroup;
    item.accessible = self.accessible;
    item.synchronizable = self.synchronizable;
    return item;
}

- (NSString *)description {
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"YYKeychainItem:{\n"];
    if (self.service) [str appendFormat:@"  service:%@,\n", self.service];
    if (self.account) [str appendFormat:@"  service:%@,\n", self.account];
    if (self.password) [str appendFormat:@"  service:%@,\n", self.password];
    if (self.label) [str appendFormat:@"  service:%@,\n", self.label];
    if (self.type) [str appendFormat:@"  service:%@,\n", self.type];
    if (self.creater) [str appendFormat:@"  service:%@,\n", self.creater];
    if (self.comment) [str appendFormat:@"  service:%@,\n", self.comment];
    if (self.descr) [str appendFormat:@"  service:%@,\n", self.descr];
    if (self.modificationDate) [str appendFormat:@"  service:%@,\n", self.modificationDate];
    if (self.creationDate) [str appendFormat:@"  service:%@,\n", self.creationDate];
    if (self.accessGroup) [str appendFormat:@"  service:%@,\n", self.accessGroup];
    [str appendString:@"}"];
    return str;
}

@end


@implementation HDKeychain

+ (NSString *)getPasswordForService:(NSString *)serviceName
                            account:(NSString *)account
                              error:(__autoreleasing NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [HDKeychain errorWithCode:errSecParam];
        return nil;
    }
    
    HDKeychainItem *item = [HDKeychainItem new];
    item.service = serviceName;
    item.account = account;
    HDKeychainItem *result = [self selectOneItem:item error:error];
    return result.password;
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName
                         account:(NSString *)account
                           error:(__autoreleasing NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [HDKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    HDKeychainItem *item = [HDKeychainItem new];
    item.service = serviceName;
    item.account = account;
    return [self deleteItem:item error:error];
}

+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account
              error:(__autoreleasing NSError **)error {
    if (!password || !serviceName || !account) {
        if (error) *error = [HDKeychain errorWithCode:errSecParam];
        return NO;
    }
    HDKeychainItem *item = [HDKeychainItem new];
    item.service = serviceName;
    item.account = account;
    HDKeychainItem *result = [self selectOneItem:item error:NULL];
    if (result) {
        result.password = password;
        return [self updateItem:result error:error];
    } else {
        return [self insertItem:item error:error];
    }
}

+ (BOOL)insertItem:(HDKeychainItem *)item error:(__autoreleasing NSError **)error {
    NSMutableDictionary *query = [item dic];
    OSStatus status = status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        if (error) *error = [HDKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)updateItem:(HDKeychainItem *)item error:(__autoreleasing NSError **)error {
    NSMutableDictionary *query = [item dic];
    OSStatus status = status = SecItemUpdate((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        if (error) *error = [HDKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteItem:(HDKeychainItem *)item error:(__autoreleasing NSError **)error {
    NSMutableDictionary *query = [item dic];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess) {
        if (error) *error = [HDKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (HDKeychainItem *)selectOneItem:(HDKeychainItem *)item error:(__autoreleasing NSError **)error {
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
        return nil;
    }
    
    NSArray *arr = (__bridge NSArray *)(result);
    HDKeychainItem *newItem = nil;
    if (arr.count) newItem = [[HDKeychainItem alloc] initWithDic:arr[0]];
    return newItem;
}

+ (NSArray *)selectItems:(HDKeychainItem *)item error:(__autoreleasing NSError **)error {
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
        return nil;
    }
    
    NSMutableArray *res = @[].mutableCopy;
    NSArray *arr = (__bridge NSArray *)(result);
    for (NSDictionary *dic in arr) {
        HDKeychainItem *item = [[HDKeychainItem alloc] initWithDic:dic];
        if (item) [res addObject:item];
    }
    
    return res;
}

+ (NSError *)errorWithCode:(OSStatus)osCode {
    HDKeychainErrorCode code = HDKeychainErrorCodeFromOSStatus(osCode);
    NSString *desc = HDKeychainErrorDesc(code);
    NSDictionary *userInfo = desc ? @{ NSLocalizedDescriptionKey : desc } : nil;
    return [NSError errorWithDomain:@"com.harvey.hdkit.keychain" code:code userInfo:userInfo];
}


@end
